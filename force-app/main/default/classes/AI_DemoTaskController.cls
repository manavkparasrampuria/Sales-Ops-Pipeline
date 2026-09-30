public with sharing class AI_DemoTaskController {
    @AuraEnabled(cacheable=true)
    public static List<AI_Demo_Task__c> getTasks(Id projectId) {
        return [
            SELECT Id, Name, Hours__c, Rate__c, Estimated_Cost__c
            FROM AI_Demo_Task__c
            WHERE Project__c = :projectId
            ORDER BY Name
        ];
    }
}