public with sharing class ForceHubTriggerHandler {

    public static void handleBeforeInsert(List<ForceHub__c> newRecords) {
        setClosedDate(newRecords, null);
    }

    public static void handleBeforeUpdate(List<ForceHub__c> newRecords, Map<Id, ForceHub__c> oldMap) {
        setClosedDate(newRecords, oldMap);
    }

    private static void setClosedDate(List<ForceHub__c> newRecords, Map<Id, ForceHub__c> oldMap) {
        for (ForceHub__c fh : newRecords) {
            ForceHub__c oldFh = (oldMap != null) ? oldMap.get(fh.Id) : null;
            Boolean statusChangedToClosed = (oldFh == null)
                ? fh.Status__c == 'Closed'
                : (fh.Status__c == 'Closed' && oldFh.Status__c != 'Closed');

            if (statusChangedToClosed && fh.Closed_Date__c == null) {
                fh.Closed_Date__c = Date.today();
            }
        }
    }
}