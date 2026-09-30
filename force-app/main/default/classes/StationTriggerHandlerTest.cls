/**
 * @description Unit tests for StationTriggerHandler.
 * @author      Copado Build Agent
 */
@Is{!Environment.IvanTest}
private class StationTriggerHandler{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Station__c station = new Station__c(
            Name         = '{!Environment.IvanTest} Station',
            Status__c    = 'Active',
            Capacity__c  = 50,
            Is_Active__c = true
        );
        insert station;
    }

    @Is{!Environment.IvanTest}
    static void testDefaultStatusOnInsert() {
        Station__c station = new Station__c(Name = 'No Status Station', Capacity__c = 10);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert station;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Station__c result = [SELECT Status__c FROM Station__c WHERE Name = 'No Status Station' LIMIT 1];
        System.assertEquals('Active', result.Status__c, 'Default status should be Active.');
    }

    @Is{!Environment.IvanTest}
    static void testStatusChangeWithDescription() {
        Station__c station = [SELECT Id FROM Station__c WHERE Name = '{!Environment.IvanTest} Station' LIMIT 1];
        station.Status__c      = 'Inactive';
        station.Description__c = 'Closing for maintenance.';
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update station;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Station__c result = [SELECT Status__c FROM Station__c WHERE Id = :station.Id];
        System.assertEquals('Inactive', result.Status__c, 'Status should be updated to Inactive.');
    }

    @Is{!Environment.IvanTest}
    static void testStatusChangeWithoutDescriptionFails() {
        Station__c station = [SELECT Id FROM Station__c WHERE Name = '{!Environment.IvanTest} Station' LIMIT 1];
        station.Status__c      = 'Inactive';
        station.Description__c = null;
        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            update station;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(exceptionThrown, 'Expected a DmlException for missing Description.');
    }

    @Is{!Environment.IvanTest}
    static void testAfterInsertLogging() {
        Station__c station = new Station__c(Name = 'Log Station', Status__c = 'Active', Capacity__c = 20);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert station;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, station.Id, 'Station should be inserted successfully.');
    }

    @Is{!Environment.IvanTest}
    static void testAfterUpdateLogging() {
        Station__c station = [SELECT Id FROM Station__c WHERE Name = '{!Environment.IvanTest} Station' LIMIT 1];
        station.Capacity__c = 75;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update station;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Station__c result = [SELECT Capacity__c FROM Station__c WHERE Id = :station.Id];
        System.assertEquals(75, result.Capacity__c, 'Capacity should be updated.');
    }
}