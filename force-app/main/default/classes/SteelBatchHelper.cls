public with sharing class SteelBatchHelper {
    public static void validateBatches(List<Steel_Batch__c> batches) {
        for (Steel_Batch__c batch : batches) {
            if (batch.Weight_tons__c != null && batch.Weight_tons__c <= 0) {
                batch.addError('Weight must be greater than zero.');
            }
        }
    }
}