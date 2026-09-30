@is{!Environment.IvanTest}
private class CommunityFeedbackTriggerHandler{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testDefaultStatusSetOnInsert() {
        Community_Feedback__c fb = new Community_Feedback__c(
            Subject__c = '{!Environment.IvanTest} Subject',
            Rating__c = 5
        );
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert fb;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Community_Feedback__c inserted = [SELECT Status__c FROM Community_Feedback__c WHERE Id = :fb.Id];
        System.assertEquals('New', inserted.Status__c, 'Status should default to New');
    }

    @is{!Environment.IvanTest}
    static void testStatusNotOverwrittenWhenProvided() {
        Community_Feedback__c fb = new Community_Feedback__c(
            Subject__c = '{!Environment.IvanTest} Subject 2',
            Rating__c = 4,
            Status__c = 'In Review'
        );
        insert fb;

        Community_Feedback__c inserted = [SELECT Status__c FROM Community_Feedback__c WHERE Id = :fb.Id];
        System.assertEquals('In Review', inserted.Status__c, 'Status should not be overwritten when explicitly provided');
    }
}