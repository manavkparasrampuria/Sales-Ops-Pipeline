public with sharing class ForceHubController {

    @AuraEnabled(cacheable=true)
    public static List<ForceHub__c> getForceHubs() {
        return [
            SELECT Id, Name, Status__c, Amount__c, Description__c, Closed_Date__c, Days_Open__c, Total_Amount__c
            FROM ForceHub__c
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }
}