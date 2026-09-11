@is{!Environment.IvanTest}
private class MachaServiceController{!Environment.IvanTest} {

    private static Macha__c buildRecord(String status, String priority, Boolean isActive, Integer daysFromNow) {
        Macha__c rec = new Macha__c();
        rec.Status__c = status;
        rec.Priority__c = priority;
        rec.Is_Active__c = isActive;
        rec.Estimated_Hours__c = 8;
        if (daysFromNow != null) {
            rec.Due_Date__c = Date.today().addDays(daysFromNow);
        }
        return rec;
    }

    @{!Environment.IvanTest}Setup
    static void setupData() {
        List<Macha__c> records = new List<Macha__c>();
        for (Integer i = 0; i < 5; i++) {
            records.add(buildRecord('New', 'Medium', true, 3));
        }
        insert records;
    }

    @is{!Environment.IvanTest}
    static void testGetMachaRecordsNoFilter() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Macha__c> results = MachaServiceController.getMachaRecords(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(results.size() > 0, 'Should return records when no filter applied');
    }

    @is{!Environment.IvanTest}
    static void testGetMachaRecordsWithFilter() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Macha__c> results = MachaServiceController.getMachaRecords('New');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        for (Macha__c r : results) {
            System.assertEquals('New', r.Status__c, 'All returned records should have status New');
        }
    }

    @is{!Environment.IvanTest}
    static void testSaveMachaRecordInsert() {
        Macha__c rec = buildRecord('New', 'High', true, null);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Macha__c saved = MachaServiceController.saveMachaRecord(rec);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, saved.Id, 'Saved record should have an Id');
    }

    @is{!Environment.IvanTest}
    static void testSaveMachaRecordNull() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            MachaServiceController.saveMachaRecord(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(true, exceptionThrown, 'Should throw exception for null record');
    }

    @is{!Environment.IvanTest}
    static void testSaveMachaRecordDmlError() {
        Macha__c rec = buildRecord('New', 'High', true, 5);
        rec.Actual_Hours__c = 10000;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            MachaServiceController.saveMachaRecord(rec);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(true, exceptionThrown, 'Should throw AuraHandledException for DML error');
    }

    @is{!Environment.IvanTest}
    static void testDeleteMachaRecord() {
        Macha__c rec = [SELECT Id FROM Macha__c LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        MachaServiceController.deleteMachaRecord(rec.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Integer count = [SELECT COUNT() FROM Macha__c WHERE Id = :rec.Id];
        System.assertEquals(0, count, 'Record should be deleted');
    }

    @is{!Environment.IvanTest}
    static void testDeleteMachaRecordNullId() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            MachaServiceController.deleteMachaRecord(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(true, exceptionThrown, 'Should throw exception for null Id');
    }
}