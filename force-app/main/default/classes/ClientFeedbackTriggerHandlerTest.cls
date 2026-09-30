@is{!Environment.IvanTest}
private class ClientFeedbackTriggerHandler{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testDefaultFeedbackDateSetWhenBlank() {
        Account acc = new Account(Name = 'Trigger {!Environment.IvanTest} Account');
        insert acc;

        Client_Feedback__c cf = new Client_Feedback__c(
            Account__c = acc.Id,
            Rating__c = '3',
            Category__c = 'Support',
            Comments__c = '{!Environment.IvanTest}ing default date'
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert cf;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Client_Feedback__c result = [SELECT Feedback_Date__c FROM Client_Feedback__c WHERE Id = :cf.Id];
        System.assertEquals(Date.today(), result.Feedback_Date__c, 'Feedback Date should default to today');
    }

    @is{!Environment.IvanTest}
    static void testFeedbackDateNotOverwrittenWhenProvided() {
        Account acc = new Account(Name = 'Trigger {!Environment.IvanTest} Account 2');
        insert acc;

        Date customDate = Date.today().addDays(-5);
        Client_Feedback__c cf = new Client_Feedback__c(
            Account__c = acc.Id,
            Rating__c = '4',
            Category__c = 'Billing',
            Feedback_Date__c = customDate,
            Comments__c = 'Custom date test'
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert cf;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Client_Feedback__c result = [SELECT Feedback_Date__c FROM Client_Feedback__c WHERE Id = :cf.Id];
        System.assertEquals(customDate, result.Feedback_Date__c, 'Feedback Date should remain as provided');
    }

    @is{!Environment.IvanTest}
    static void testValidationRuleBlocksLowRatingWithoutComments() {
        Account acc = new Account(Name = 'Validation {!Environment.IvanTest} Account');
        insert acc;

        Client_Feedback__c cf = new Client_Feedback__c(
            Account__c = acc.Id,
            Rating__c = '1',
            Category__c = 'Support',
            Feedback_Date__c = Date.today()
        );

        Boolean errorCaught = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert cf;
        } catch (DmlException e) {
            errorCaught = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(true, errorCaught, 'Should throw error for low rating without comments');
    }
}