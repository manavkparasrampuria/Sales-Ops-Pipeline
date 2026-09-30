/**
 * @description Unit tests for CloudBridgeRequestTriggerHandler / CloudBridgeRequestTrigger.
 * Uses a test data factory method (buildRequest) as required by the
 * CloudBridge technical specifications.
 */
@is{!Environment.IvanTest}
private class CloudBridgeRequestTriggerHandler{!Environment.IvanTest} {

    private static CloudBridge_Request__c buildRequest(String priority, String status, String description) {
        CloudBridge_Request__c request = new CloudBridge_Request__c();
        if (String.isNotBlank(priority)) {
            request.Priority__c = priority;
        }
        request.Status__c = status;
        request.Description__c = description;
        return request;
    }

    @is{!Environment.IvanTest}
    static void testDefaultsPriorityOnInsertWhenBlank() {
        CloudBridge_Request__c request = buildRequest(null, 'New', 'Initial request');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert request;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        CloudBridge_Request__c inserted = [
            SELECT Priority__c, Status__c, Is_High_Priority__c
            FROM CloudBridge_Request__c
            WHERE Id = :request.Id
        ];
        System.assertEquals('Medium', inserted.Priority__c, 'Priority should default to Medium when left blank.');
        System.assertEquals(false, inserted.Is_High_Priority__c, 'Is_High_Priority__c should be false for Medium priority.');
    }

    @is{!Environment.IvanTest}
    static void testKeepsExplicitPriorityOnInsert() {
        CloudBridge_Request__c request = buildRequest('High', 'New', 'Urgent request');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert request;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        CloudBridge_Request__c inserted = [
            SELECT Priority__c, Is_High_Priority__c
            FROM CloudBridge_Request__c
            WHERE Id = :request.Id
        ];
        System.assertEquals('High', inserted.Priority__c, 'Explicit priority should not be overwritten.');
        System.assertEquals(true, inserted.Is_High_Priority__c, 'Is_High_Priority__c should be true for High priority.');
    }

    @is{!Environment.IvanTest}
    static void testBlocksRejectedMovingDirectlyToApproved() {
        CloudBridge_Request__c request = buildRequest('Medium', 'Rejected', 'Needs rework');
        insert request;

        request.Status__c = 'Approved';

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Database.SaveResult result = Database.update(request, false);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(false, result.isSuccess(), 'Rejected requests should not be movable directly to Approved.');
        System.assertEquals(
            'A Rejected CloudBridge Request cannot be moved directly to Approved. Please move it to New or In Review first.',
            result.getErrors()[0].getMessage(),
            'Error message returned by addError should match the expected validation text.'
        );
    }

    @is{!Environment.IvanTest}
    static void testAllowsRejectedMovingToInReview() {
        CloudBridge_Request__c request = buildRequest('Medium', 'Rejected', 'Needs rework');
        insert request;

        request.Status__c = 'In Review';

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update request;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        CloudBridge_Request__c updated = [SELECT Status__c FROM CloudBridge_Request__c WHERE Id = :request.Id];
        System.assertEquals('In Review', updated.Status__c, 'Rejected requests should be movable to In Review.');
    }

    @is{!Environment.IvanTest}
    static void testValidationRuleRequiresDescriptionWhenApproved() {
        CloudBridge_Request__c request = buildRequest('Medium', 'Approved', null);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Database.SaveResult result = Database.insert(request, false);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(false, result.isSuccess(), 'Approving a request without a Description should fail validation.');
    }

    @is{!Environment.IvanTest}
    static void testRollUpSummarySumsChildAmounts() {
        CloudBridge_Request__c request = buildRequest('Medium', 'New', 'Parent for roll-up test');
        insert request;

        List<CloudBridge_Request_Item__c> items = new List<CloudBridge_Request_Item__c>{
            new CloudBridge_Request_Item__c(CloudBridge_Request__c = request.Id, Amount__c = 100),
            new CloudBridge_Request_Item__c(CloudBridge_Request__c = request.Id, Amount__c = 50)
        };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert items;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        CloudBridge_Request__c updated = [SELECT Total_Amount__c FROM CloudBridge_Request__c WHERE Id = :request.Id];
        System.assertEquals(150, updated.Total_Amount__c, 'Total_Amount__c roll-up should sum all child Amount__c values.');
    }

    @is{!Environment.IvanTest}
    static void testCloudBridgeExceptionCanBeThrownAndCaught() {
        Boolean caught = false;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            throw new CloudBridgeException('CloudBridge business rule violation');
        } catch (CloudBridgeException e) {
            caught = true;
            System.assertEquals('CloudBridge business rule violation', e.getMessage(), 'Exception message should match the message it was constructed with.');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(true, caught, 'CloudBridgeException should be catchable as its own type.');
    }

    @is{!Environment.IvanTest}
    static void testBulkInsertOfTwoHundredRecordsDefaultsPriority() {
        List<CloudBridge_Request__c> requests = new List<CloudBridge_Request__c>();
        for (Integer i = 0; i < 200; i++) {
            requests.add(buildRequest(null, 'New', 'Bulk request ' + i));
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert requests;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Integer defaultedCount = [
            SELECT COUNT()
            FROM CloudBridge_Request__c
            WHERE Priority__c = 'Medium'
        ];
        System.assertEquals(200, defaultedCount, 'All 200 bulk-inserted records should have Priority defaulted to Medium.');
    }
}