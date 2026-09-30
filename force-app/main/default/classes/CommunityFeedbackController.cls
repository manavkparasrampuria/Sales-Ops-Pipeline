public with sharing class CommunityFeedbackController {
    @AuraEnabled
    public static Id submitFeedback(String subject, String description, Integer rating) {
        if (String.isBlank(subject) || rating == null) {
            throw new AuraHandledException('Subject and Rating are required.');
        }
        if (!Schema.sObjectType.Community_Feedback__c.isCreateable()) {
            throw new AuraHandledException('Insufficient permissions to create feedback.');
        }

        Community_Feedback__c feedback = new Community_Feedback__c(
            Subject__c = subject,
            Description__c = description,
            Rating__c = rating,
            Community_User__c = UserInfo.getUserId()
        );

        try {
            insert feedback;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        }
        return feedback.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<Community_Feedback__c> getMyFeedback() {
        if (!Schema.sObjectType.Community_Feedback__c.isAccessible()) {
            return new List<Community_Feedback__c>();
        }
        List<Community_Feedback__c> results = [
            SELECT Id, Name, Subject__c, Description__c, Rating__c, Status__c, Is_Resolved__c, Total_Comments__c
            FROM Community_Feedback__c
            WHERE Community_User__c = :UserInfo.getUserId()
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, results);
        return decision.getRecords();
    }
}