public with sharing class ProjectTaskController {

    @AuraEnabled(cacheable=true)
    public static List<ProjectTask__c> getProjectTasks() {
        return [
            SELECT Id, Name, Status__c, Priority__c, Due_Date__c,
                   Completed_Date__c, Days_Until_Due__c
            FROM ProjectTask__c
            WITH SECURITY_ENFORCED
            ORDER BY Due_Date__c ASC NULLS LAST
            LIMIT 200
        ];
    }

    @AuraEnabled
    public static String getOverdueMessage() {
        return System.Label.Project_Task_Overdue_Message;
    }
}