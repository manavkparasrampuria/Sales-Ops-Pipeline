@is{!Environment.IvanTest}
private class ClientFeedbackController{!Environment.IvanTest} {
    @testSetup
    static void setup() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account');
        insert acc;
        Client_Feedback__c cf = new Client_Feedback__c(
            Account__c = acc.Id,
            Rating__c = '5',
            Category__c = 'Product',
            Feedback_Date__c = Date.today(),
            Comments__c = 'Great service'
        );
        insert cf;

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Client_Feedback_Access' LIMIT 1];
        insert new PermissionSetAssignment(
            AssigneeId = UserInfo.getUserId(),
            PermissionSetId = ps.Id
        );
    }

    @is{!Environment.IvanTest}
    static void testGetClientFeedback() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Client_Feedback__c> results = ClientFeedbackController.getClientFeedback(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(1, results.size(), 'Should return one feedback record');
    }

    @is{!Environment.IvanTest}
    static void testGetNegativeFeedbackMessage() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String message = ClientFeedbackController.getNegativeFeedbackMessage();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, message, 'Label value should not be null');
    }
}