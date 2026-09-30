@is{!Environment.IvanTest}
private class AI_DemoTaskController{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testGetTasksReturnsRelatedTasks() {
        AI_Demo_Project__c project = new AI_Demo_Project__c(Name = 'Controller {!Environment.IvanTest} Project', Status__c = 'Planning', Budget__c = 2000);
        insert project;

        insert new AI_Demo_Task__c(Name = 'Controller Task', Project__c = project.Id, Hours__c = 4, Rate__c = 60);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<AI_Demo_Task__c> results = AI_DemoTaskController.getTasks(project.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, results.size(), 'Should return one task for the project');
    }
}