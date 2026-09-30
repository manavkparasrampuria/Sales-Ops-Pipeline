/**
 * @description Unit tests for ProjectService.
 *              Covers getActiveProjects, createProject, getProjectsByStatus,
 *              and validation rule enforcement.
 */
@Is{!Environment.IvanTest}
private class ProjectService{!Environment.IvanTest} {

    // ─── Helpers ────────────────────────────────────────────────────────────

    private static Project__c makeProject(String name, String status, Date start, Date finish, Decimal budget) {
        return new Project__c(
            Name          = name,
            Status__c     = status,
            Start_Date__c = start,
            End_Date__c   = finish,
            Budget__c     = budget
        );
    }

    // ─── getActiveProjects ───────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testGetActiveProjects_returnsOnlyActive() {
        Date today = Date.today();
        List<Project__c> toInsert = new List<Project__c>{
            makeProject('Active Project 1', 'Active',    today, today.addDays(10), 1000),
            makeProject('Active Project 2', 'Active',    today, today.addDays(20), 2000),
            makeProject('Draft Project',    'Draft',     today, today.addDays(5),  500),
            makeProject('Completed Proj',   'Completed', today, today.addDays(1),  100)
        };
        insert toInsert;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Project__c> results = ProjectService.getActiveProjects();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(2, results.size(), 'Should return only Active projects');
        for (Project__c p : results) {
            System.assertEquals('Active', p.Status__c, 'All returned projects must be Active');
        }
    }

    @Is{!Environment.IvanTest}
    static void testGetActiveProjects_noActiveRecords_returnsEmpty() {
        Date today = Date.today();
        insert makeProject('Draft Only', 'Draft', today, today.addDays(5), 0);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Project__c> results = ProjectService.getActiveProjects();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(0, results.size(), 'Should return empty list when no Active projects exist');
    }

    // ─── createProject ───────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testCreateProject_insertsRecord() {
        Date today = Date.today();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Id projId = ProjectService.createProject('New Project', 'Active', today, today.addDays(30), 5000);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Project__c inserted = [SELECT Id, Name, Status__c, Budget__c FROM Project__c WHERE Id = :projId];
        System.assertEquals('New Project', inserted.Name,      'Name should match');
        System.assertEquals('Active',      inserted.Status__c, 'Status should match');
        System.assertEquals(5000,          inserted.Budget__c, 'Budget should match');
    }

    // ─── getProjectsByStatus ─────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testGetProjectsByStatus_returnsMatchingRecords() {
        Date today = Date.today();
        insert new List<Project__c>{
            makeProject('P1', 'Active',    today, today.addDays(10), 100),
            makeProject('P2', 'Active',    today, today.addDays(10), 200),
            makeProject('P3', 'Completed', today, today.addDays(1),  300)
        };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Project__c> results = ProjectService.getProjectsByStatus('Active');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(2, results.size(), 'Should return 2 Active projects');
    }

    @Is{!Environment.IvanTest}
    static void testGetProjectsByStatus_nullStatus_returnsEmpty() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Project__c> results = ProjectService.getProjectsByStatus(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(0, results.size(), 'Null status should return empty list');
    }

    @Is{!Environment.IvanTest}
    static void testGetProjectsByStatus_blankStatus_returnsEmpty() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Project__c> results = ProjectService.getProjectsByStatus('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(0, results.size(), 'Blank status should return empty list');
    }

    // ─── Validation Rules ────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testValidationRule_endDateBeforeStartDate_throwsError() {
        Date today = Date.today();
        Project__c bad = makeProject('Bad Dates', 'Draft', today, today.addDays(-1), 0);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert bad;
            System.assert(false, 'Expected DmlException for end date before start date');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('End Date must be on or after the Start Date'),
                'Expected end-date validation message, got: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testValidationRule_negativeBudget_throwsError() {
        Date today = Date.today();
        Project__c bad = makeProject('Negative Budget', 'Draft', today, today.addDays(5), -100);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert bad;
            System.assert(false, 'Expected DmlException for negative budget');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Budget must be a positive value'),
                'Expected budget validation message, got: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}