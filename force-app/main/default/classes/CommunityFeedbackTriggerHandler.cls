public with sharing class CommunityFeedbackTriggerHandler {
    public static void beforeInsert(List<Community_Feedback__c> newRecords) {
        for (Community_Feedback__c fb : newRecords) {
            if (String.isBlank(fb.Status__c)) {
                fb.Status__c = 'New';
            }
        }
    }
}