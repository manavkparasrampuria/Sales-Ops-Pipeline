@Is{!Environment.IvanTest}
private class MyHomeService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        List<MyHome__c> homes = new List<MyHome__c>{
            new MyHome__c(
                Name = '{!Environment.IvanTest} Home 1',
                Address__c = '123 Main St',
                Price__c = 500000,
                Status__c = 'Available',
                Bedrooms__c = 3,
                Bathrooms__c = 2,
                Square_Footage__c = 1800,
                Listed_Date__c = Date.today().addDays(-10),
                Is_Featured__c = true
            ),
            new MyHome__c(
                Name = '{!Environment.IvanTest} Home 2',
                Address__c = '456 Oak Ave',
                Price__c = 750000,
                Status__c = 'Under Contract',
                Bedrooms__c = 4,
                Bathrooms__c = 3,
                Square_Footage__c = 2500,
                Listed_Date__c = Date.today().addDays(-5),
                Is_Featured__c = false
            )
        };
        insert homes;
    }

    @Is{!Environment.IvanTest}
    static void testGetAvailableHomes() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<MyHome__c> result = MyHomeService.getAvailableHomes();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(0, result.size(), 'Should return at least one available home');
        for (MyHome__c h : result) {
            System.assertEquals('Available', h.Status__c, 'All homes should be Available');
        }
    }

    @Is{!Environment.IvanTest}
    static void testGetFeaturedHomes() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<MyHome__c> result = MyHomeService.getFeaturedHomes();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(0, result.size(), 'Should return at least one featured home');
        for (MyHome__c h : result) {
            System.assertEquals(true, h.Is_Featured__c, 'All homes should be featured');
        }
    }

    @Is{!Environment.IvanTest}
    static void testUpdateHomeStatus() {
        MyHome__c home = [SELECT Id FROM MyHome__c WHERE Name = '{!Environment.IvanTest} Home 1' LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        MyHomeService.updateHomeStatus(home.Id, 'Under Contract');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        MyHome__c updated = [SELECT Status__c FROM MyHome__c WHERE Id = :home.Id];
        System.assertEquals('Under Contract', updated.Status__c, 'Status should be updated');
    }

    @Is{!Environment.IvanTest}
    static void testMarkAsFeatured() {
        MyHome__c home = [SELECT Id FROM MyHome__c WHERE Name = '{!Environment.IvanTest} Home 2' LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        MyHomeService.markAsFeatured(home.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        MyHome__c updated = [SELECT Is_Featured__c FROM MyHome__c WHERE Id = :home.Id];
        System.assertEquals(true, updated.Is_Featured__c, 'Home should be marked as featured');
    }

    @Is{!Environment.IvanTest}
    static void testUpdateHomeStatusException() {
        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            MyHomeService.updateHomeStatus(null, '');
        } catch (MyHomeService.MyHomeException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(exceptionThrown, 'Exception should be thrown for null inputs');
    }
}