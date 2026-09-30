/**
 * @description {!Environment.IvanTest} class for EmployeeOnboardingTriggerHandler and EmployeeOnboardingService.
 * @author      Copado Build Agent
 * @date        2026-08-14
 */
@is{!Environment.IvanTest}
private class EmployeeOnboardingTriggerHandler{!Environment.IvanTest} {

    private static Employee_Onboarding__c buildRecord(String employeeName) {
        return new Employee_Onboarding__c(
            Employee_Name__c = employeeName,
            Department__c    = 'Engineering',
            Joining_Date__c  = Date.today(),
            Email__c         = 'test@example.com',
            Notes__c         = '{!Environment.IvanTest} notes'
        );
    }

    @is{!Environment.IvanTest}
    static void testSingleInsertSetsStatusInProgress() {
        Employee_Onboarding__c record = buildRecord('John Doe');
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert record;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Employee_Onboarding__c inserted = [SELECT Status__c FROM Employee_Onboarding__c WHERE Id = :record.Id];
        Assert.areEqual('In Progress', inserted.Status__c, 'Status should be In Progress on insert.');
    }

    @is{!Environment.IvanTest}
    static void testBulkInsertSetsStatusInProgress() {
        List<Employee_Onboarding__c> records = new List<Employee_Onboarding__c>();
        for (Integer i = 0; i < 200; i++) {
            records.add(buildRecord('Employee ' + i));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert records;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Employee_Onboarding__c> inserted = [SELECT Status__c FROM Employee_Onboarding__c WHERE Id IN :records];
        Assert.areEqual(200, inserted.size(), 'All 200 records should be inserted.');
        for (Employee_Onboarding__c rec : inserted) {
            Assert.areEqual('In Progress', rec.Status__c, 'Every record should have Status = In Progress.');
        }
    }

    @is{!Environment.IvanTest}
    static void testServiceGetRecords() {
        insert new List<Employee_Onboarding__c>{ buildRecord('Alice'), buildRecord('Bob') };
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Employee_Onboarding__c> result = EmployeeOnboardingService.getRecords();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.isTrue(result.size() >= 2, 'getRecords() should return at least 2 records.');
    }

    @is{!Environment.IvanTest}
    static void testServiceGetRecordsByStatus() {
        insert buildRecord('Charlie');
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Employee_Onboarding__c> inProgress = EmployeeOnboardingService.getRecordsByStatus('In Progress');
        List<Employee_Onboarding__c> completed  = EmployeeOnboardingService.getRecordsByStatus('Completed');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.isTrue(inProgress.size() >= 1, 'Should return at least 1 In Progress record.');
        Assert.areEqual(0, completed.size(), 'Should return 0 Completed records.');
    }

    @is{!Environment.IvanTest}
    static void testServiceGetRecordsByStatusBlankInput() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Employee_Onboarding__c> result = EmployeeOnboardingService.getRecordsByStatus('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.areEqual(0, result.size(), 'Blank status should return empty list.');
    }
}