/**
 * @description Trigger handler for Service_Request__c.
 *              Follows the one-trigger-per-object pattern with a dedicated handler class.
 */
public with sharing class ServiceRequestTriggerHandler {

    // ─── Entry Points ────────────────────────────────────────────────────────

    public static void handleBeforeInsert(List<Service_Request__c> newList) {
        setDefaultStatus(newList);
        setSLADueDate(newList);
    }

    public static void handleBeforeUpdate(List<Service_Request__c> newList, Map<Id, Service_Request__c> oldMap) {
        checkEscalation(newList, oldMap);
        setSLADueDate(newList);
    }

    public static void handleAfterInsert(List<Service_Request__c> newList) {
        // Reserved for future after-insert logic (e.g. notifications)
    }

    public static void handleAfterUpdate(List<Service_Request__c> newList, Map<Id, Service_Request__c> oldMap) {
        // Reserved for future after-update logic
    }

    // ─── Private Helpers ─────────────────────────────────────────────────────

    /**
     * Sets Status to 'New' if not provided on insert.
     */
    private static void setDefaultStatus(List<Service_Request__c> newList) {
        for (Service_Request__c sr : newList) {
            if (String.isBlank(sr.Status__c)) {
                sr.Status__c = 'New';
            }
        }
    }

    /**
     * Sets SLA Due Date to 5 business days from today if not already set.
     */
    private static void setSLADueDate(List<Service_Request__c> newList) {
        for (Service_Request__c sr : newList) {
            if (sr.SLA_Due_Date__c == null) {
                sr.SLA_Due_Date__c = Date.today().addDays(5);
            }
        }
    }

    /**
     * Marks Is_Escalated__c = true when Status changes to 'On Hold'
     * (indicating the request is blocked and needs escalation attention).
     */
    private static void checkEscalation(List<Service_Request__c> newList, Map<Id, Service_Request__c> oldMap) {
        for (Service_Request__c sr : newList) {
            Service_Request__c oldSr = oldMap.get(sr.Id);
            if (sr.Status__c == 'On Hold' && oldSr.Status__c != 'On Hold') {
                sr.Is_Escalated__c = true;
            }
        }
    }
}