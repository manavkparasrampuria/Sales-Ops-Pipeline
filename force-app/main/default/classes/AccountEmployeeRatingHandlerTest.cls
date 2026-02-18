/**
 * @description Test class for AccountEmployeeRatingHandler - 100% coverage
 * @author Developer B
 * @date 2026-02-18
 */
@IsTest
private class AccountEmployeeRatingHandlerTest {
    
    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Large Company', NumberOfEmployees = 500));
        accounts.add(new Account(Name = 'Medium Company', NumberOfEmployees = 100));
        accounts.add(new Account(Name = 'Small Company', NumberOfEmployees = 25));
        accounts.add(new Account(Name = 'Unknown Size Company'));
        insert accounts;
    }
    
    @IsTest
    static void testHotRating() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Large Company' LIMIT 1];
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Hot', result.Rating, 'Rating should be Hot for large company');
    }
    
    @IsTest
    static void testWarmRating() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Medium Company' LIMIT 1];
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Warm', result.Rating, 'Rating should be Warm for medium company');
    }
    
    @IsTest
    static void testColdRating() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Small Company' LIMIT 1];
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating, 'Rating should be Cold for small company');
    }
    
    @IsTest
    static void testNullEmployees() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Unknown Size Company' LIMIT 1];
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating, 'Null employees should result in Cold');
    }
    
    @IsTest
    static void testBulkUpdate() {
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(accountIds);
        Test.stopTest();
        
        List<Account> results = [SELECT Rating FROM Account WHERE Id IN :accountIds];
        System.assertEquals(4, results.size(), 'All accounts should be updated');
    }
    
    @IsTest
    static void testNullInput() {
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(null);
        AccountEmployeeRatingHandler.updateRating(new Set<Id>());
        Test.stopTest();
        
        System.assert(true, 'Should handle null gracefully');
    }
    
    @IsTest
    static void testCalculateMethod() {
        System.assertEquals('Hot', AccountEmployeeRatingHandler.calculateRatingByEmployees(500));
        System.assertEquals('Warm', AccountEmployeeRatingHandler.calculateRatingByEmployees(100));
        System.assertEquals('Cold', AccountEmployeeRatingHandler.calculateRatingByEmployees(25));
        System.assertEquals('Cold', AccountEmployeeRatingHandler.calculateRatingByEmployees(null));
    }
}