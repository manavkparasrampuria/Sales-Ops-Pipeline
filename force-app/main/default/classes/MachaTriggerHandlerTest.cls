@is{!Environment.IvanTest}
private class MachaTriggerHandler{!Environment.IvanTest} {

    private static Macha__c buildRecord(String priority, String status, Boolean isActive, Integer daysFromNow) {
        Macha__c rec = new Macha__c();
        rec.Priority__c = priority;
        rec.Status__c = status;
        rec.Is_Active__c = isActive;
        rec.Estimated_Hours__c = 10;
        if (daysFromNow != null) {
            rec.Due_Date__c = Date.today().addDays(daysFromNow);
        }
        return rec;
    }

    @{!Environment.IvanTest}Setup
    static void setupData() {
        List<Macha__c> records = new List<Macha__c>();
        for (Integer i = 0; i < 5; i++) {
            records.add(buildRecord('High', 'New', true, 5));
        }
        insert records;
    }

    @is{!Environment.IvanTest}
    static void testDefaultsOnInsert() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Macha__c rec = new Macha__c();
        insert rec;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Macha__c inserted = [SELECT Status__c, Priority__c, Is_Active__c FROM Macha__c WHERE Id = :rec.Id];
        System.assertEquals('New', inserted.Status__c, 'Default status should be New');
        System.assertEquals('Medium', inserted.Priority__c, 'Default priority should be Medium');
        System.assertEquals(true, inserted.Is_Active__c, 'Default Is_Active should be true');
    }

    @is{!Environment.IvanTest}
    static void testBulkInsert() {
        List<Macha__c> bulkRecords = new List<Macha__c>();
        for (Integer i = 0; i < 200; i++) {
            bulkRecords.add(buildRecord('Low', 'New', true, 10));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert bulkRecords;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Integer count = [SELECT COUNT() FROM Macha__c WHERE Priority__c = 'Low'];
        System.assertEquals(200, count, 'All 200 bulk records should be inserted');
    }

    @is{!Environment.IvanTest}
    static void testCannotRevertCompletedRecord() {
        Macha__c rec = buildRecord('High', 'Completed', true, 5);
        insert rec;

        Macha__c afterInsert = [SELECT Id, Status__c FROM Macha__c WHERE Id = :rec.Id];
        System.assertEquals('Completed', afterInsert.Status__c, 'Record should be Completed after insert');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            afterInsert.Status__c = 'New';
            update afterInsert;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(true, exceptionThrown, 'Should not allow reverting a completed record');
    }

    @is{!Environment.IvanTest}
    static void testUpdateWithNoStatusChange() {
        Macha__c rec = [SELECT Id, Status__c FROM Macha__c LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        rec.Priority__c = 'Low';
        update rec;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Macha__c updated = [SELECT Priority__c FROM Macha__c WHERE Id = :rec.Id];
        System.assertEquals('Low', updated.Priority__c, 'Priority should be updated to Low');
    }
}