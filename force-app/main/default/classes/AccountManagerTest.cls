@IsTest
private class AccountManagerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create minimal test data
        Account testAccount = new Account(
            Name = 'Test Account',
            Industry = 'Technology',
            AnnualRevenue = 100000
        );
        insert testAccount;
    }
    
    // This test will FAIL - intentionally incorrect assertion
    @IsTest
    static void testCreateAccount_Fail() {
        Test.startTest();
        Account newAccount = AccountManager.createAccount('New Test Account', 'Finance');
        Test.stopTest();
        
        // FAILING ASSERTION - expecting wrong industry
        System.assertEquals('Technology', newAccount.Industry, 
            'Expected Technology but this will fail');
        
        // This assertion will also fail
        System.assertEquals(null, newAccount.Id, 
            'Account should not have an ID but it does - FAIL');
    }
    
    // This test covers only ONE method - giving approximately 10% coverage
    // (1 out of 10 methods = 10%)
    @IsTest
    static void testValidateAccountData_Pass() {
        Account validAccount = new Account(
            Name = 'Valid Account Name',
            AnnualRevenue = 50000
        );
        
        Test.startTest();
        Boolean isValid = AccountManager.validateAccountData(validAccount);
        Test.stopTest();
        
        System.assertEquals(true, isValid, 'Account should be valid');
    }
}