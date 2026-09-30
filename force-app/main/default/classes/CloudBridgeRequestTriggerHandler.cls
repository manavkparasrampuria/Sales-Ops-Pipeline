/**
 * @description Handler class for the CloudBridgeRequestTrigger, following the
 * one-trigger-per-object / handler-class pattern required by the
 * CloudBridge metadata foundation.
 *
 * All methods are bulkified (no SOQL or DML inside loops) so the class
 * operates safely within governor limits for bulk data scenarios.
 */
public with sharing class CloudBridgeRequestTriggerHandler {

    private static final String STATUS_REJECTED = 'Rejected';
    private static final String STATUS_APPROVED = 'Approved';
    private static final String PRIORITY_MEDIUM = 'Medium';
    private static final String ERROR_REJECTED_TO_APPROVED =
        'A Rejected CloudBridge Request cannot be moved directly to Approved. Please move it to New or In Review first.';

    /**
     * @description Single entry point invoked by CloudBridgeRequestTrigger so the
     * trigger body itself contains no branching logic, per the
     * AvoidLogicInTrigger best practice. Routes to the appropriate
     * before-insert / before-update handler based on the trigger context.
     * @param newRequests The list of CloudBridge_Request__c records from Trigger.new.
     * @param oldMap The map of old CloudBridge_Request__c records from Trigger.oldMap (null on insert).
     * @param isBefore Whether the trigger is executing in a before context.
     * @param isInsert Whether the trigger is executing for an insert operation.
     * @param isUpdate Whether the trigger is executing for an update operation.
     */
    public static void dispatch(
        List<CloudBridge_Request__c> newRequests,
        Map<Id, CloudBridge_Request__c> oldMap,
        Boolean isBefore,
        Boolean isInsert,
        Boolean isUpdate
    ) {
        CloudBridgeRequestTriggerHandler handler = new CloudBridgeRequestTriggerHandler();
        if (isBefore && isInsert) {
            handler.handleBeforeInsert(newRequests);
        } else if (isBefore && isUpdate) {
            handler.handleBeforeUpdate(newRequests, oldMap);
        }
    }

    /**
     * @description Defaults Priority__c to 'Medium' for any CloudBridge Request that is
     * inserted without an explicit priority, so downstream automation and
     * reporting never have to deal with a blank priority value.
     * @param newRequests The list of CloudBridge_Request__c records being inserted.
     */
    public void handleBeforeInsert(List<CloudBridge_Request__c> newRequests) {
        if (newRequests == null) {
            return;
        }
        for (CloudBridge_Request__c request : newRequests) {
            if (String.isBlank(request.Priority__c)) {
                request.Priority__c = PRIORITY_MEDIUM;
            }
        }
    }

    /**
     * @description Guards against a Rejected request being moved directly to Approved,
     * protecting the integrity of the approval workflow. Uses addError so
     * the calling trigger surfaces a clear, field-level message to the user.
     * @param newRequests The list of CloudBridge_Request__c records being updated.
     * @param oldMap The map of old CloudBridge_Request__c versions keyed by Id.
     */
    public void handleBeforeUpdate(List<CloudBridge_Request__c> newRequests, Map<Id, CloudBridge_Request__c> oldMap) {
        if (newRequests == null || oldMap == null) {
            return;
        }
        for (CloudBridge_Request__c request : newRequests) {
            CloudBridge_Request__c oldRequest = oldMap.get(request.Id);
            if (oldRequest == null) {
                continue;
            }
            if (isRejectedMovingToApproved(oldRequest, request)) {
                request.addError(ERROR_REJECTED_TO_APPROVED);
            }
        }
    }

    /**
     * @description Determines whether a single CloudBridge Request is transitioning
     * directly from Rejected to Approved, extracted into its own method to
     * keep handleBeforeUpdate simple and to avoid literal string comparisons
     * scattered across the class.
     * @param oldRequest The prior version of the record being evaluated.
     * @param newRequest The incoming version of the record being evaluated.
     * @return True if the record is moving from Rejected directly to Approved.
     */
    private Boolean isRejectedMovingToApproved(CloudBridge_Request__c oldRequest, CloudBridge_Request__c newRequest) {
        Boolean wasRejected = oldRequest.Status__c == STATUS_REJECTED;
        Boolean movingToApproved = newRequest.Status__c == STATUS_APPROVED;
        return wasRejected && movingToApproved;
    }
}