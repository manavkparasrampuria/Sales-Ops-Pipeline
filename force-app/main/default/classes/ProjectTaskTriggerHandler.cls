public with sharing class ProjectTaskTriggerHandler {

    public static void handleBeforeInsertUpdate(List<Project_Task__c> newList, Map<Id, Project_Task__c> oldMap) {
        for (Project_Task__c task : newList) {
            if (task.Story_Points__c == 0 && task.Status__c == 'Open') {
                task.Status__c = 'Completed';
            }
            if (oldMap != null) {
                Project_Task__c oldTask = oldMap.get(task.Id);
                if (oldTask != null && oldTask.Status__c == 'Completed' && task.Status__c == 'Open' && task.Due_Date__c == null) {
                    task.addError('Cannot reopen a completed task without setting a new Due Date.');
                }
            }
        }
    }

    public static void handleAfterInsertUpdate(List<Project_Task__c> newList, Map<Id, Project_Task__c> oldMap) {
        Set<Id> projectIds = new Set<Id>();
        for (Project_Task__c task : newList) {
            if (oldMap == null || oldMap.get(task.Id).Status__c != task.Status__c) {
                projectIds.add(task.Project__c);
            }
        }
        if (!projectIds.isEmpty()) {
            updateProjectStatus(projectIds);
        }
    }

    private static void updateProjectStatus(Set<Id> projectIds) {
        List<Project_Management__c> projectsToUpdate = new List<Project_Management__c>();
        for (Id projId : projectIds) {
            List<Project_Task__c> tasks = [
                SELECT Status__c FROM Project_Task__c WHERE Project__c = :projId
            ];
            Boolean allDone = true;
            Boolean anyInProgress = false;
            for (Project_Task__c t : tasks) {
                if (t.Status__c != 'Completed') allDone = false;
                if (t.Status__c == 'In Progress') anyInProgress = true;
            }
            String newStatus = allDone ? 'Completed' : (anyInProgress ? 'In Progress' : 'Not Started');
            projectsToUpdate.add(new Project_Management__c(Id = projId, Status__c = newStatus));
        }
        if (!projectsToUpdate.isEmpty()) {
            update projectsToUpdate;
        }
    }
}