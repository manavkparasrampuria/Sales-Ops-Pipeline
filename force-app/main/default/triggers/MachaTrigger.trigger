trigger MachaTrigger on Macha__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            MachaTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            MachaTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            MachaTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            MachaTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}