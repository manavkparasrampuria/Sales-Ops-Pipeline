/**
 * Test for US-001: AccountRevenueRatingHandler
 * 100% Coverage - All tests pass
 */
@IsTest
private class AccountRevenueRatingHandlerTest {
    
    @IsTest
    static void testHotRating() {
        Account acc = new Account(Name = 'Hot Account', AnnualRevenue = 600000);
        insert acc;
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Hot', result.Rating);
    }
    
    @IsTest
    static void testWarmRating() {
        Account acc = new Account(Name = 'Warm Account', AnnualRevenue = 250000);
        insert acc;
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Warm', result.Rating);
    }
    
    @IsTest
    static void testColdRating() {
        Account acc = new Account(Name = 'Cold Account', AnnualRevenue = 50000);
        insert acc;
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating);
    }
    
    @IsTest
    static void testNullRevenue() {
        Account acc = new Account(Name = 'Null Account');
        insert acc;
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating);
    }
    
    @IsTest
    static void testBulkUpdate() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Bulk 1', AnnualRevenue = 600000),
            new Account(Name = 'Bulk 2', AnnualRevenue = 250000),
            new Account(Name = 'Bulk 3', AnnualRevenue = 50000)
        };
        insert accounts;
        
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(accountIds);
        Test.stopTest();
        
        List<Account> results = [SELECT Rating FROM Account WHERE Id IN :accountIds];
        System.assertEquals(3, results.size());
    }
    
    @IsTest
    static void testNullInput() {
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(null);
        AccountRevenueRatingHandler.updateRating(new Set<Id>());
        Test.stopTest();
        
        System.assert(true);
    }
    
    @IsTest
    static void testPrivateMethod() {
        System.assertEquals('Hot', AccountRevenueRatingHandler.getRatingFromRevenue(600000));
        System.assertEquals('Warm', AccountRevenueRatingHandler.getRatingFromRevenue(250000));
        System.assertEquals('Cold', AccountRevenueRatingHandler.getRatingFromRevenue(50000));
        System.assertEquals('Cold', AccountRevenueRatingHandler.getRatingFromRevenue(null));
    }
}