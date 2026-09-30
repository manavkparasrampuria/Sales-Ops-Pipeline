/**
 * @description Controller for the serviceRequestForm and serviceRequestManager LWC components.
 *              Uses the Case object as the backing SObject since ServiceRequest__c
 *              is not yet deployed. Fields map: Subject -> Subject, Description -> Description,
 *              Priority -> Priority, Category -> Origin.
 * @author      Copado Build Agent
 * @date        2026-09-03
 */
public with sharing class ServiceRequestController {

    /**
     * @description Returns recent Cases ordered by creation date.
     * @return List of Case records
     */
    @AuraEnabled(cacheable=true)
    public static List<Case> getServiceRequests() {
        return [
            SELECT Id, Subject, Status, Priority, Origin, Description
            FROM Case
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }

    /**
     * @description Creates a new Case record representing a service request.
     * @param subject     Case subject
     * @param description Case description
     * @param priority    Priority (Low / Medium / High / Critical)
     * @param category    Mapped to Origin field
     * @return            Id of the newly created Case
     */
    @AuraEnabled
    public static Id createServiceRequest(
        String subject,
        String description,
        String priority,
        String category
    ) {
        if (String.isBlank(subject)) {
            throw new AuraHandledException('Subject is required.');
        }
        if (String.isBlank(category)) {
            throw new AuraHandledException('Category is required.');
        }

        Case c = new Case(
            Subject     = subject,
            Description = description,
            Priority    = priority,
            Origin      = category,
            Status      = 'New'
        );

        try {
            insert c;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }

        return c.Id;
    }

    /**
     * @description Updates the Status of an existing Case (service request).
     * @param requestId  Id of the Case to update
     * @param newStatus  New status value (e.g. 'Working', 'Closed')
     */
    @AuraEnabled
    public static void updateServiceRequestStatus(Id requestId, String newStatus) {
        if (requestId == null) {
            throw new AuraHandledException('Request Id is required.');
        }
        if (String.isBlank(newStatus)) {
            throw new AuraHandledException('New status is required.');
        }

        Case c = new Case(
            Id     = requestId,
            Status = newStatus
        );

        try {
            update c;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}