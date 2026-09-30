public with sharing class ProjectTaskService {

    @AuraEnabled(cacheable=true)
    public static List<Project_Task__c> getTasksByProject(Id projectId) {
        return [
            SELECT Id, Name, Status__c, Due_Date__c, Assigned_To__c, Story_Points__c, Is_Overdue__c
            FROM Project_Task__c
            WHERE Project__c = :projectId
            ORDER BY Due_Date__c ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Project_Task__c> getOverdueTasks() {
        return [
            SELECT Id, Name, Status__c, Due_Date__c, Assigned_To__r.Name, Project__r.Name
            FROM Project_Task__c
            WHERE Is_Overdue__c = true
            ORDER BY Due_Date__c ASC
        ];
    }

    @AuraEnabled
    public static void updateTaskStatus(Id taskId, String newStatus) {
        Project_Task__c task = [SELECT Id, Status__c FROM Project_Task__c WHERE Id = :taskId LIMIT 1];
        task.Status__c = newStatus;
        update task;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getTaskSummaryByStatus(Id projectId) {
        Map<String, Integer> summary = new Map<String, Integer>();
        for (AggregateResult ar : [
            SELECT Status__c status, COUNT(Id) cnt
            FROM Project_Task__c
            WHERE Project__c = :projectId
            GROUP BY Status__c
        ]) {
            summary.put((String) ar.get('status'), (Integer) ar.get('cnt'));
        }
        return summary;
    }
}