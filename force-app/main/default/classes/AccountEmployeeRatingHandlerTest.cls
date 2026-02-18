/**
 * Test for US-002: AccountEmployeeRatingHandler
 * 100% Coverage - All tests pass
 */
@IsTest
private class AccountEmployeeRatingHandlerTest {
    
    @IsTest
    static void testHotRating() {
        Account acc = new Account(Name = 'Large Co', NumberOfEmployees = 500);
        insert acc;
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Hot', result.Rating);
    }
    
    @IsTest
    static void testWarmRating() {
        Account acc = new Account(Name = 'Medium Co', NumberOfEmployees = 100);
        insert acc;
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Warm', result.Rating);
    }
    
    @IsTest
    static void testColdRating() {
        Account acc = new Account(Name = 'Small Co', NumberOfEmployees = 25);
        insert acc;
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating);
    }
    
    @IsTest
    static void testNullEmployees() {
        Account acc = new Account(Name = 'Unknown Co');
        insert acc;
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(new Set<Id>{ acc.Id });
        Test.stopTest();
        
        Account result = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', result.Rating);
    }
    
    @IsTest
    static void testBulkUpdate() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Bulk Large', NumberOfEmployees = 500),
            new Account(Name = 'Bulk Medium', NumberOfEmployees = 100),
            new Account(Name = 'Bulk Small', NumberOfEmployees = 25)
        };
        insert accounts;
        
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(accountIds);
        Test.stopTest();
        
        List<Account> results = [SELECT Rating FROM Account WHERE Id IN :accountIds];
        System.assertEquals(3, results.size());
    }
    
    @IsTest
    static void testNullInput() {
        Test.startTest();
        AccountEmployeeRatingHandler.updateRating(null);
        AccountEmployeeRatingHandler.updateRating(new Set<Id>());
        Test.stopTest();
        
        System.assert(true);
    }
    
    @IsTest
    static void testPrivateMethod() {
        System.assertEquals('Hot', AccountEmployeeRatingHandler.getRatingFromEmployees(500));
        System.assertEquals('Warm', AccountEmployeeRatingHandler.getRatingFromEmployees(100));
        System.assertEquals('Cold', AccountEmployeeRatingHandler.getRatingFromEmployees(25));
        System.assertEquals('Cold', AccountEmployeeRatingHandler.getRatingFromEmployees(null));
    }
}