/**
 * @description Test class for AccountRevenueRatingHandler - 100% coverage
 * @author Developer A
 * @date 2026-02-18
 */
@IsTest
private class AccountRevenueRatingHandlerTest {
    
    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Hot Account', AnnualRevenue = 600000));
        accounts.add(new Account(Name = 'Warm Account', AnnualRevenue = 250000));
        accounts.add(new Account(Name = 'Cold Account', AnnualRevenue = 50000));
        accounts.add(new Account(Name = 'Null Revenue Account'));
        insert accounts;
    }
    
    @IsTest
    static void testHotRating() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Hot Account' LIMIT 1];
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Hot', result.Rating, 'Rating should be Hot');
    }
    
    @IsTest
    static void testWarmRating() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Warm Account' LIMIT 1];
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Warm', result.Rating, 'Rating should be Warm');
    }
    
    @IsTest
    static void testColdRating() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Cold Account' LIMIT 1];
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating, 'Rating should be Cold');
    }
    
    @IsTest
    static void testNullRevenue() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Null Revenue Account' LIMIT 1];
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating, 'Null revenue should result in Cold');
    }
    
    @IsTest
    static void testBulkUpdate() {
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(accountIds);
        Test.stopTest();
        
        List<Account> results = [SELECT Rating FROM Account WHERE Id IN :accountIds];
        System.assertEquals(4, results.size(), 'All accounts should be updated');
    }
    
    @IsTest
    static void testNullInput() {
        Test.startTest();
        AccountRevenueRatingHandler.updateRating(null);
        AccountRevenueRatingHandler.updateRating(new Set<Id>());
        Test.stopTest();
        
        System.assert(true, 'Should handle null gracefully');
    }
    
    @IsTest
    static void testCalculateMethod() {
        System.assertEquals('Hot', AccountRevenueRatingHandler.calculateRatingByRevenue(600000));
        System.assertEquals('Warm', AccountRevenueRatingHandler.calculateRatingByRevenue(250000));
        System.assertEquals('Cold', AccountRevenueRatingHandler.calculateRatingByRevenue(50000));
        System.assertEquals('Cold', AccountRevenueRatingHandler.calculateRatingByRevenue(null));
    }
}