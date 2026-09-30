@Is{!Environment.IvanTest}
private class AccountManager{!Environment.IvanTest} {
    
    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        // Create minimal test data
        Account testAccount = new Account(
            Name = '{!Environment.IvanTest} Account',
            Industry = 'Technology',
            AnnualRevenue = 100000
        );
        insert testAccount;
    }
    
    // This test will FAIL - intentionally incorrect assertion
    @Is{!Environment.IvanTest}
    static void testCreateAccount_Fail() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Account newAccount = AccountManager.createAccount('New {!Environment.IvanTest} Account', 'Finance');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        // FAILING ASSERTION - expecting wrong industry
        System.assertEquals('Technology', newAccount.Industry, 
            'Expected Technology but this will fail');
        
        // This assertion will also fail
        System.assertEquals(null, newAccount.Id, 
            'Account should not have an ID but it does - FAIL');
    }
    
    // This test covers only ONE method - giving approximately 10% coverage
    // (1 out of 10 methods = 10%)
    @Is{!Environment.IvanTest}
    static void testValidateAccountData_Pass() {
        Account validAccount = new Account(
            Name = 'Valid Account Name',
            AnnualRevenue = 50000
        );
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean isValid = AccountManager.validateAccountData(validAccount);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        System.assertEquals(true, isValid, 'Account should be valid');
    }
}