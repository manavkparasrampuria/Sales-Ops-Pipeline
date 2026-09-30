@Is{!Environment.IvanTest}
private class ProjectTaskService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        Project_Management__c proj = new Project_Management__c(
            Name = '{!Environment.IvanTest} Project',
            Status__c = 'In Progress',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(30),
            Budget__c = 10000,
            Priority__c = 'High'
        );
        insert proj;

        List<Project_Task__c> tasks = new List<Project_Task__c>{
            new Project_Task__c(Name = 'Task 1', Project__c = proj.Id, Status__c = 'Open', Due_Date__c = Date.today().addDays(5), Story_Points__c = 3),
            new Project_Task__c(Name = 'Task 2', Project__c = proj.Id, Status__c = 'In Progress', Due_Date__c = Date.today().addDays(10), Story_Points__c = 5),
            new Project_Task__c(Name = 'Task 3', Project__c = proj.Id, Status__c = 'Completed', Due_Date__c = Date.today().addDays(-2), Story_Points__c = 2)
        };
        insert tasks;
    }

    @Is{!Environment.IvanTest}
    static void testGetTasksByProject() {
        Project_Management__c proj = [SELECT Id FROM Project_Management__c LIMIT 1];
        List<Project_Task__c> tasks = ProjectTaskService.getTasksByProject(proj.Id);
        System.assertEquals(3, tasks.size(), 'Should return 3 tasks');
    }

    @Is{!Environment.IvanTest}
    static void testGetOverdueTasks() {
        List<Project_Task__c> overdue = ProjectTaskService.getOverdueTasks();
        System.assert(overdue != null, 'Overdue list should not be null');
    }

    @Is{!Environment.IvanTest}
    static void testUpdateTaskStatus() {
        Project_Task__c task = [SELECT Id FROM Project_Task__c WHERE Name = 'Task 1' LIMIT 1];
        ProjectTaskService.updateTaskStatus(task.Id, 'Completed');
        Project_Task__c updated = [SELECT Status__c FROM Project_Task__c WHERE Id = :task.Id];
        System.assertEquals('Completed', updated.Status__c, 'Status should be Completed');
    }

    @Is{!Environment.IvanTest}
    static void testGetTaskSummaryByStatus() {
        Project_Management__c proj = [SELECT Id FROM Project_Management__c LIMIT 1];
        Map<String, Integer> summary = ProjectTaskService.getTaskSummaryByStatus(proj.Id);
        System.assert(!summary.isEmpty(), 'Summary should not be empty');
    }
}