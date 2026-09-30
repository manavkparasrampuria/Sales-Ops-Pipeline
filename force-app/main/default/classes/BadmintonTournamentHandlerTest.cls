@is{!Environment.IvanTest}
private class BadmintonTournamentHandler{!Environment.IvanTest} {

    @testSetup
    static void setupData() {
        Badminton_Tournament__c t = new Badminton_Tournament__c(
            Name = '{!Environment.IvanTest} Tournament',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(3),
            Location__c = '{!Environment.IvanTest} Arena'
        );
        insert t;
    }

    @is{!Environment.IvanTest}
    static void testValidDates() {
        Badminton_Tournament__c t = new Badminton_Tournament__c(
            Name = 'Valid Tournament',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5),
            Location__c = 'Arena A'
        );
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert t;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Badminton_Tournament__c inserted = [SELECT Id, Name FROM Badminton_Tournament__c WHERE Name = 'Valid Tournament' LIMIT 1];
        System.assertNotEquals(null, inserted.Id, 'Tournament should be inserted successfully.');
    }

    @is{!Environment.IvanTest}
    static void testInvalidDates() {
        Badminton_Tournament__c t = new Badminton_Tournament__c(
            Name = 'Invalid Tournament',
            Start_Date__c = Date.today().addDays(5),
            End_Date__c = Date.today(),
            Location__c = 'Arena B'
        );
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert t;
            System.assert(false, 'Expected exception was not thrown.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('End Date cannot be before Start Date.'), 'Correct error message expected.');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testAfterInsertHandler() {
        Badminton_Tournament__c t = new Badminton_Tournament__c(
            Name = 'After Insert Tournament',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(2),
            Location__c = 'Arena C'
        );
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert t;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, t.Id, 'Tournament Id should not be null after insert.');
    }

    @is{!Environment.IvanTest}
    static void testAfterUpdateHandler() {
        Badminton_Tournament__c t = [SELECT Id, End_Date__c FROM Badminton_Tournament__c LIMIT 1];
        t.End_Date__c = Date.today().addDays(7);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update t;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Badminton_Tournament__c updated = [SELECT Id, End_Date__c FROM Badminton_Tournament__c WHERE Id = :t.Id];
        System.assertEquals(Date.today().addDays(7), updated.End_Date__c, 'End date should be updated.');
    }
}