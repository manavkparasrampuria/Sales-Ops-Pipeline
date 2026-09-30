@is{!Environment.IvanTest}
private class ProjectTaskController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        insert new ProjectTask__c(
            Name = '{!Environment.IvanTest} Task',
            Status__c = 'Not Started',
            Priority__c = 'Medium',
            Due_Date__c = Date.today().addDays(5)
        );

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            Alias = 'ptmtst',
            Email = 'ptm.test.user@example.com.invalid',
            EmailEncodingKey = 'UTF-8',
            LastName = 'ProjectTask{!Environment.IvanTest}User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'ptm.test.' + DateTime.now().getTime() + '@example.com.invalid',
            ProfileId = p.Id
        );
        insert u;

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Project_Task_Manager' LIMIT 1];
        insert new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );
    }

    @is{!Environment.IvanTest}
    static void testGetProjectTasks() {
        User testUser = [SELECT Id FROM User WHERE LastName = 'ProjectTask{!Environment.IvanTest}User' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<ProjectTask__c> tasks;
        System.runAs(testUser) {
            tasks = ProjectTaskController.getProjectTasks();
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, tasks.size(), 'Expected one task to be returned');
    }

    @is{!Environment.IvanTest}
    static void testGetOverdueMessage() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String msg = ProjectTaskController.getOverdueMessage();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, msg, 'Overdue message should not be null');
    }

    @is{!Environment.IvanTest}
    static void testCompletedDateAutoPopulated() {
        ProjectTask__c task = [SELECT Id, Status__c, Completed_Date__c FROM ProjectTask__c LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        task.Status__c = 'Completed';
        update task;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        ProjectTask__c updated = [SELECT Completed_Date__c FROM ProjectTask__c WHERE Id = :task.Id];
        System.assertEquals(Date.today(), updated.Completed_Date__c, 'Completed Date should be auto-populated by the flow');
    }
}