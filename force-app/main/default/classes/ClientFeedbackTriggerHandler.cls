public class ClientFeedbackTriggerHandler {
    public static void setDefaultFeedbackDate(List<Client_Feedback__c> newRecords) {
        for (Client_Feedback__c cf : newRecords) {
            if (cf.Feedback_Date__c == null) {
                cf.Feedback_Date__c = Date.today();
            }
        }
    }
}