trigger SteelBatchTrigger on Steel_Batch__c (before insert, before update) {
    SteelBatchHelper.validateBatches(Trigger.new);
}