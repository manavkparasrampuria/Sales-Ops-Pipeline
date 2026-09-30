@is{!Environment.IvanTest}
private class ServiceRequestTriggerHandler{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Factory ────────────────────────────────────────────────────

    private static Service_Request__c buildRequest(String priority, String description) {
        return new Service_Request__c(
            Priority__c    = priority,
            Description__c = description
        );
    }

    // ─── {!Environment.IvanTest}s ────────────────────────────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testDefaultStatusOnInsert() {
        Service_Request__c sr = buildRequest('Low', '{!Environment.IvanTest}ing default status');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert sr;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Service_Request__c result = [SELECT Status__c FROM Service_Request__c WHERE Id = :sr.Id];
        System.assertEquals('New', result.Status__c, 'Default status should be New');
    }

    @is{!Environment.IvanTest}
    static void testSLADueDateOnInsert() {
        Service_Request__c sr = buildRequest('High', '{!Environment.IvanTest}ing SLA due date');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert sr;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Service_Request__c result = [SELECT SLA_Due_Date__c FROM Service_Request__c WHERE Id = :sr.Id];
        System.assertNotEquals(null, result.SLA_Due_Date__c, 'SLA Due Date should be set');
        System.assertEquals(Date.today().addDays(5), result.SLA_Due_Date__c, 'SLA Due Date should be today + 5 days');
    }

    @is{!Environment.IvanTest}
    static void testEscalationFlagOnUpdate() {
        // Insert with default status 'New'
        Service_Request__c sr = buildRequest('High', '{!Environment.IvanTest}ing escalation flag');
        insert sr;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        sr.Status__c = 'On Hold';
        update sr;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Service_Request__c result = [SELECT Is_Escalated__c FROM Service_Request__c WHERE Id = :sr.Id];
        System.assertEquals(true, result.Is_Escalated__c, 'Is_Escalated__c should be true when status moves to On Hold');
    }

    @is{!Environment.IvanTest}
    static void testNoEscalationWhenStatusUnchanged() {
        Service_Request__c sr = buildRequest('Medium', '{!Environment.IvanTest}ing no escalation');
        insert sr;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        sr.Status__c = 'In Progress';
        update sr;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Service_Request__c result = [SELECT Is_Escalated__c FROM Service_Request__c WHERE Id = :sr.Id];
        System.assertNotEquals(true, result.Is_Escalated__c, 'Is_Escalated__c should not be set for In Progress');
    }

    @is{!Environment.IvanTest}
    static void testSLADueDatePreservedOnUpdate() {
        Service_Request__c sr = buildRequest('Medium', '{!Environment.IvanTest}ing SLA preserved on update');
        insert sr;

        Date customSLA = Date.today().addDays(10);
        sr.SLA_Due_Date__c = customSLA;
        update sr;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        sr.Status__c = 'In Progress';
        update sr;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Service_Request__c result = [SELECT SLA_Due_Date__c FROM Service_Request__c WHERE Id = :sr.Id];
        System.assertEquals(customSLA, result.SLA_Due_Date__c, 'SLA Due Date should be preserved when already set');
    }

    @is{!Environment.IvanTest}
    static void testAfterInsertAndAfterUpdateCoverage() {
        // Exercises the after insert and after update handler paths.
        // Resolution_Date__c is required by validation rule when Status = Resolved.
        Service_Request__c sr = buildRequest('Low', 'After trigger coverage');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert sr;
        sr.Status__c       = 'Resolved';
        sr.Resolution_Date__c = Date.today();
        update sr;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, sr.Id, 'Record should have been inserted');
    }

    @is{!Environment.IvanTest}
    static void testBulkInsert() {
        List<Service_Request__c> bulkList = new List<Service_Request__c>();
        for (Integer i = 0; i < 200; i++) {
            bulkList.add(buildRequest('Medium', 'Bulk test ' + i));
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert bulkList;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Service_Request__c> results = [
            SELECT SLA_Due_Date__c, Status__c
            FROM Service_Request__c
            WHERE Id IN :bulkList
        ];
        System.assertEquals(200, results.size(), 'All 200 records should be inserted');
        for (Service_Request__c r : results) {
            System.assertEquals('New', r.Status__c, 'All bulk records should have status New');
            System.assertNotEquals(null, r.SLA_Due_Date__c, 'All bulk records should have SLA Due Date');
        }
    }
}