public with sharing class ClientFeedbackController {
    @AuraEnabled(cacheable=true)
    public static List<Client_Feedback__c> getClientFeedback(Id accountId) {
        List<Client_Feedback__c> records = [
            SELECT Id, Name, Rating__c, Category__c, Feedback_Date__c, Comments__c
            FROM Client_Feedback__c
            WHERE Account__c = :accountId
            ORDER BY Feedback_Date__c DESC
            LIMIT 200
        ];
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, records);
        return (List<Client_Feedback__c>) decision.getRecords();
    }

    @AuraEnabled(cacheable=true)
    public static String getNegativeFeedbackMessage() {
        return System.Label.Negative_Feedback_Alert_Message;
    }
}