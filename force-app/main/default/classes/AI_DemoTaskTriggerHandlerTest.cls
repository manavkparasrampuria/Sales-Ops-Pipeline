@is{!Environment.IvanTest}
private class AI_DemoTaskTriggerHandler{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testDefaultRateAppliedWhenBlank() {
        AI_Demo_Project__c project = new AI_Demo_Project__c(Name = '{!Environment.IvanTest} Project', Status__c = 'Planning', Budget__c = 10000);
        insert project;

        AI_Demo_Task__c task = new AI_Demo_Task__c(Name = '{!Environment.IvanTest} Task', Project__c = project.Id, Hours__c = 5);
        insert task;

        task = [SELECT Rate__c FROM AI_Demo_Task__c WHERE Id = :task.Id];
        System.assertEquals(50, task.Rate__c, 'Default rate should be applied when blank');
    }

    @is{!Environment.IvanTest}
    static void testExistingRateNotOverwritten() {
        AI_Demo_Project__c project = new AI_Demo_Project__c(Name = '{!Environment.IvanTest} Project 2', Status__c = 'Planning', Budget__c = 5000);
        insert project;

        AI_Demo_Task__c task = new AI_Demo_Task__c(Name = '{!Environment.IvanTest} Task 2', Project__c = project.Id, Hours__c = 3, Rate__c = 75);
        insert task;

        task = [SELECT Rate__c FROM AI_Demo_Task__c WHERE Id = :task.Id];
        System.assertEquals(75, task.Rate__c, 'Existing rate should not be overwritten');
    }
}