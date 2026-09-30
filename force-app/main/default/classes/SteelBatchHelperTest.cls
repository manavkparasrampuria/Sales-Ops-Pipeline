@is{!Environment.IvanTest}
private class SteelBatchHelper{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testValidBatch() {
        Steel_Batch__c batch = new Steel_Batch__c(Weight_tons__c = 10, Carbon_Content_Percent__c = 1.5);
        insert batch;
        System.assertNotEquals(null, batch.Id, 'Batch should be inserted successfully.');
    }
    
    @is{!Environment.IvanTest}
    static void testInvalidWeight() {
        Steel_Batch__c batch = new Steel_Batch__c(Weight_tons__c = -5, Carbon_Content_Percent__c = 1.5);
        try {
            insert batch;
            System.assert(false, 'Exception should have been thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Weight must be greater than zero.'), 'Expected validation error on weight.');
        }
    }
}