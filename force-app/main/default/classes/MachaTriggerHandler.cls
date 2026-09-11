public with sharing class MachaTriggerHandler {

    public static void handleBeforeInsert(List<Macha__c> newList) {
        setDefaults(newList);
    }

    public static void handleBeforeUpdate(List<Macha__c> newList, Map<Id, Macha__c> oldMap) {
        setDefaults(newList);
        validateStatusTransition(newList, oldMap);
    }

    public static void handleAfterInsert(List<Macha__c> newList) {
        // Reserved for future after-insert logic
    }

    public static void handleAfterUpdate(List<Macha__c> newList, Map<Id, Macha__c> oldMap) {
        // Reserved for future after-update logic
    }

    private static void setDefaults(List<Macha__c> records) {
        for (Macha__c rec : records) {
            if (String.isBlank(rec.Status__c)) {
                rec.Status__c = 'New';
            }
            if (String.isBlank(rec.Priority__c)) {
                rec.Priority__c = 'Medium';
            }
            if (!rec.Is_Active__c) {
                rec.Is_Active__c = true;
            }
        }
    }

    private static void validateStatusTransition(List<Macha__c> newList, Map<Id, Macha__c> oldMap) {
        for (Macha__c rec : newList) {
            Macha__c oldRec = oldMap.get(rec.Id);
            if (oldRec.Status__c == 'Completed' && rec.Status__c != 'Completed') {
                rec.addError('A completed Macha record cannot be moved back to a prior status.');
            }
        }
    }
}