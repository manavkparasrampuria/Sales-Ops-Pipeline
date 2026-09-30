public with sharing class ElectronicDocumentTriggerHandler {
    public static Boolean bypassTrigger = false;

    public static void run(List<Electronic_Document__c> newList, List<Electronic_Document__c> oldList, Map<Id,Electronic_Document__c> newMap, Map<Id,Electronic_Document__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isBefore, Boolean isAfter) {
        if (bypassTrigger) return;
        if (isBefore && isInsert) { onBeforeInsert(newList); }
        if (isBefore && isUpdate) { onBeforeUpdate(newList, oldMap); }
        if (isAfter  && isInsert) { onAfterInsert(newList); }
        if (isAfter  && isUpdate) { onAfterUpdate(newList, oldMap); }
    }

    private static void onBeforeInsert(List<Electronic_Document__c> newList) {
        for (Electronic_Document__c doc : newList) {
            if (doc.EM_Version__c == null) { doc.EM_Version__c = 1; }
            if (doc.EM_Status__c  == null) { doc.EM_Status__c  = 'Draft'; }
        }
    }

    private static void onBeforeUpdate(List<Electronic_Document__c> newList, Map<Id,Electronic_Document__c> oldMap) {
        for (Electronic_Document__c doc : newList) {
            Electronic_Document__c oldDoc = oldMap.get(doc.Id);
            if (oldDoc.EM_Status__c == 'Approved' && doc.EM_Status__c == 'Draft') {
                doc.EM_Status__c.addError(Label.EM_Error_Cannot_Revert_Approved);
            }
            if (oldDoc.EM_Status__c == 'Archived') {
                doc.addError(Label.EM_Error_Cannot_Edit_Archived);
            }
        }
    }

    private static void onAfterInsert(List<Electronic_Document__c> newList) { }
    private static void onAfterUpdate(List<Electronic_Document__c> newList, Map<Id,Electronic_Document__c> oldMap) { }
}