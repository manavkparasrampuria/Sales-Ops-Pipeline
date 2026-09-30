@is{!Environment.IvanTest}
private class ForceHubController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        insert new ForceHub__c(Name = 'Setup Hub', Status__c = 'New', Amount__c = 200);
    }

    @is{!Environment.IvanTest}
    static void testGetForceHubs_ReturnsRecords() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<ForceHub__c> results = ForceHubController.getForceHubs();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, results.size(), 'Should return one ForceHub__c record');
        System.assertEquals('Setup Hub', results[0].Name, 'Returned record should match the one created in setup');
    }
}