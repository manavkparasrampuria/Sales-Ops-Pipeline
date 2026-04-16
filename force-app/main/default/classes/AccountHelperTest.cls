/**
 * @description {!Environment.IvanTest} class for AccountHelper - includes intentional delay to make test visible
 */
@Is{!Environment.IvanTest}
private class AccountHelper{!Environment.IvanTest} {
    
    /**
     * @description Setup test data
     */
    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        List<Account> testAccounts = new List<Account>();
        
        // Create 50 accounts to make the test take longer
        for (Integer i = 0; i < 50; i++) {
            testAccounts.add(new Account(
                Name = '{!Environment.IvanTest} Account ' + i,
                Industry = 'Technology',
                AnnualRevenue = 100000 * i
            ));
        }
        
        insert testAccounts;
        
        // Add a small delay to make test visible in monitoring
        Long startTime = System.now().getTime();
        while (System.now().getTime() - startTime < 2000) {
            // Wait for 2 seconds
        }
    }
    
    /**
     * @description {!Environment.IvanTest} createAccounts method
     */
    @Is{!Environment.IvanTest}
    static void testCreateAccounts() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        
        // Call the method
        List<Account> accounts = AccountHelper.createAccounts(10, '{!Environment.IvanTest} Account');
        
        // Assertions
        System.assertEquals(10, accounts.size(), 'Should create 10 accounts');
        System.assertEquals('{!Environment.IvanTest} Account 0', accounts[0].Name, 'First account name should be correct');
        System.assertEquals('Technology', accounts[0].Industry, 'Industry should be Technology');
        System.assertEquals('Prospect', accounts[0].Type, 'Type should be Prospect');
        
        // Add delay to make test visible
        Long startTime = System.now().getTime();
        while (System.now().getTime() - startTime < 3000) {
            // Wait for 3 seconds
        }
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
    
    /**
     * @description {!Environment.IvanTest} getAccountCountByIndustry method
     */
    @Is{!Environment.IvanTest}
    static void testGetAccountCountByIndustry() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        
        // Call the method
        Integer count = AccountHelper.getAccountCountByIndustry('Technology');
        
        // Assertions
        System.assertEquals(50, count, 'Should return 50 Technology accounts');
        
        // {!Environment.IvanTest} with non-existent industry
        Integer zeroCount = AccountHelper.getAccountCountByIndustry('Manufacturing');
        System.assertEquals(0, zeroCount, 'Should return 0 for non-existent industry');
        
        // Add delay to make test visible
        Long startTime = System.now().getTime();
        while (System.now().getTime() - startTime < 3000) {
            // Wait for 3 seconds
        }
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
    
    /**
     * @description {!Environment.IvanTest} updateAccountRatings method with Hot rating
     */
    @Is{!Environment.IvanTest}
    static void testUpdateAccountRatingsHot() {
        // Query accounts with high revenue
        List<Account> highRevenueAccounts = [
            SELECT Id, AnnualRevenue, Rating
            FROM Account
            WHERE AnnualRevenue >= 1000000
            LIMIT 10
        ];
        
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : highRevenueAccounts) {
            accountIds.add(acc.Id);
        }
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        
        // Call the method
        AccountHelper.updateAccountRatings(accountIds);
        
        // Add delay to make test visible
        Long startTime = System.now().getTime();
        while (System.now().getTime() - startTime < 3000) {
            // Wait for 3 seconds
        }
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        // Verify the ratings were updated
        List<Account> updatedAccounts = [
            SELECT Id, Rating, AnnualRevenue
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : updatedAccounts) {
            System.assertEquals('Hot', acc.Rating, 'Rating should be Hot for high revenue accounts');
        }
    }
    
    /**
     * @description {!Environment.IvanTest} updateAccountRatings method with Warm rating
     */
    @Is{!Environment.IvanTest}
    static void testUpdateAccountRatingsWarm() {
        // Query accounts with medium revenue
        List<Account> mediumRevenueAccounts = [
            SELECT Id, AnnualRevenue, Rating
            FROM Account
            WHERE AnnualRevenue >= 500000 AND AnnualRevenue < 1000000
            LIMIT 5
        ];
        
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : mediumRevenueAccounts) {
            accountIds.add(acc.Id);
        }
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        
        // Call the method
        AccountHelper.updateAccountRatings(accountIds);
        
        // Add delay to make test visible
        Long startTime = System.now().getTime();
        while (System.now().getTime() - startTime < 2000) {
            // Wait for 2 seconds
        }
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        // Verify the ratings were updated
        List<Account> updatedAccounts = [
            SELECT Id, Rating, AnnualRevenue
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : updatedAccounts) {
            System.assertEquals('Warm', acc.Rating, 'Rating should be Warm for medium revenue accounts');
        }
    }
    
    /**
     * @description {!Environment.IvanTest} bulk processing
     */
    @Is{!Environment.IvanTest}
    static void testBulkProcessing() {
        // Get all test accounts
        List<Account> allAccounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Set<Id>();
        
        for (Account acc : allAccounts) {
            accountIds.add(acc.Id);
        }
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        
        // Process all 50 accounts
        AccountHelper.updateAccountRatings(accountIds);
        
        // Add delay to make test visible
        Long startTime = System.now().getTime();
        while (System.now().getTime() - startTime < 4000) {
            // Wait for 4 seconds
        }
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        // Verify all accounts were processed
        List<Account> updatedAccounts = [
            SELECT Id, Rating
            FROM Account
            WHERE Id IN :accountIds AND Rating != null
        ];
        
        System.assert(updatedAccounts.size() > 0, 'At least some accounts should have ratings');
    }
}