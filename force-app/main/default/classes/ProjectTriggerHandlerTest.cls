/**
 * @description Unit tests for ProjectTriggerHandler.
 *              All assertions are made via DML operations so the trigger
 *              context is fully exercised without calling handler methods directly.
 */
@Is{!Environment.IvanTest}
private class ProjectTriggerHandler{!Environment.IvanTest} {

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private static Project__c buildProject(String name, String status) {
        Date today = Date.today();
        return new Project__c(
            Name          = name,
            Status__c     = status,
            Start_Date__c = today,
            End_Date__c   = today.addDays(30),
            Budget__c     = 1000
        );
    }

    // ─── Before Insert: default status ───────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testBeforeInsert_blankStatus_defaultsToDraft() {
        Project__c proj = new Project__c(
            Name          = 'No Status Project',
            Start_Date__c = Date.today(),
            End_Date__c   = Date.today().addDays(10),
            Budget__c     = 500
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert proj;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals('Draft', result.Status__c, 'Status should default to Draft when blank');
    }

    @Is{!Environment.IvanTest}
    static void testBeforeInsert_providedStatus_isPreserved() {
        Project__c proj = buildProject('Active Project', 'Active');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert proj;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals('Active', result.Status__c, 'Provided status should be preserved');
    }

    // ─── Before Update: status transition guard ───────────────────────────────

    @Is{!Environment.IvanTest}
    static void testBeforeUpdate_activeToCompleted_succeeds() {
        Project__c proj = buildProject('Transition Project', 'Active');
        insert proj;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        proj.Status__c = 'Completed';
        update proj;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals('Completed', result.Status__c, 'Active to Completed transition should succeed');
    }

    @Is{!Environment.IvanTest}
    static void testBeforeUpdate_completedToDraft_throwsError() {
        Project__c proj = buildProject('Completed Project', 'Completed');
        insert proj;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        proj.Status__c = 'Draft';
        try {
            update proj;
            System.assert(false, 'Expected DmlException when moving Completed to Draft');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('A Completed project cannot be moved back to Draft status'),
                'Expected guard error message, got: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testBeforeUpdate_completedToOnHold_succeeds() {
        Project__c proj = buildProject('On Hold Project', 'Completed');
        insert proj;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        proj.Status__c = 'On Hold';
        update proj;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Project__c result = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals('On Hold', result.Status__c, 'Completed to On Hold should be allowed');
    }

    // ─── Bulk insert ──────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testBulkInsert_200Records_defaultStatus() {
        List<Project__c> projects = new List<Project__c>();
        Date today = Date.today();
        for (Integer i = 0; i < 200; i++) {
            projects.add(new Project__c(
                Name          = 'Bulk Project ' + i,
                Start_Date__c = today,
                End_Date__c   = today.addDays(30),
                Budget__c     = 100
            ));
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert projects;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Project__c> results = [SELECT Status__c FROM Project__c WHERE Status__c = 'Draft'];
        System.assertEquals(200, results.size(), 'All 200 bulk-inserted projects should default to Draft');
    }
}