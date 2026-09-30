/**
 * @description {!Environment.IvanTest} class for ServiceRequestController.
 *              Covers getServiceRequests, createServiceRequest, and updateServiceRequestStatus.
 * @author      Copado Build Agent
 * @date        2026-09-03
 */
@is{!Environment.IvanTest}
private class ServiceRequestController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Case c = new Case(
            Subject  = '{!Environment.IvanTest} Service Request',
            Priority = 'High',
            Origin   = 'Technical',
            Status   = 'New'
        );
        insert c;
    }

    @is{!Environment.IvanTest}
    static void testGetServiceRequests() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Case> results = ServiceRequestController.getServiceRequests();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.isNotNull(results, 'Results should not be null');
        Assert.isTrue(results.size() >= 1, 'Should return at least 1 record');
    }

    @is{!Environment.IvanTest}
    static void testCreateServiceRequest_Success() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Id caseId = ServiceRequestController.createServiceRequest(
            'New Request', '{!Environment.IvanTest} description', 'Medium', 'Billing'
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.isNotNull(caseId, 'Case Id should not be null');
        Case created = [SELECT Subject FROM Case WHERE Id = :caseId];
        Assert.areEqual('New Request', created.Subject, 'Subject should match');
    }

    @is{!Environment.IvanTest}
    static void testCreateServiceRequest_BlankSubject() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            ServiceRequestController.createServiceRequest('', 'desc', 'Low', 'General');
            Assert.fail('Exception expected for blank subject');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage(), 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testCreateServiceRequest_BlankCategory() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            ServiceRequestController.createServiceRequest('Subject', 'desc', 'Low', '');
            Assert.fail('Exception expected for blank category');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage(), 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testUpdateServiceRequestStatus_Success() {
        Case existing = [SELECT Id FROM Case LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ServiceRequestController.updateServiceRequestStatus(existing.Id, 'Working');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Case updated = [SELECT Status FROM Case WHERE Id = :existing.Id];
        Assert.areEqual('Working', updated.Status, 'Status should be updated to Working');
    }

    @is{!Environment.IvanTest}
    static void testUpdateServiceRequestStatus_NullId() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            ServiceRequestController.updateServiceRequestStatus(null, 'Working');
            Assert.fail('Exception expected for null requestId');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage(), 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testUpdateServiceRequestStatus_BlankStatus() {
        Case existing = [SELECT Id FROM Case LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            ServiceRequestController.updateServiceRequestStatus(existing.Id, '');
            Assert.fail('Exception expected for blank status');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage(), 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}