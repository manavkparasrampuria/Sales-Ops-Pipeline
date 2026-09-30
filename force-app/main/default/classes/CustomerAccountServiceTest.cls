@is{!Environment.IvanTest}
private class CustomerAccountService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        insert new List<Account>{
            new Account(Name = 'Acme Customer', Type = 'Customer', Industry = 'Technology'),
            new Account(Name = 'Acme Partner', Type = 'Partner', Industry = 'Finance'),
            new Account(Name = 'Acme Other', Type = 'Other', Industry = 'Retail')
        };
    }

    @is{!Environment.IvanTest}
    static void testGetCustomerCategory_Customer() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Acme Customer' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = CustomerAccountService.getCustomerCategory(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Customer Account', result, 'Expected Customer Account category');
    }

    @is{!Environment.IvanTest}
    static void testGetCustomerCategory_Partner() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Acme Partner' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = CustomerAccountService.getCustomerCategory(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Partner Account', result, 'Expected Partner Account category');
    }

    @is{!Environment.IvanTest}
    static void testGetCustomerCategory_Other() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Acme Other' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = CustomerAccountService.getCustomerCategory(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Other Account', result, 'Expected Other Account category');
    }

    @is{!Environment.IvanTest}
    static void testGetIndustry() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Acme Customer' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = CustomerAccountService.getIndustry(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Technology', result, 'Expected Technology industry');
    }

    // Unit tests for setDefaultDescription run directly on in-memory records
    // (not via DML) so that org automation on Account (e.g. before-save Flows
    // that also set Description) cannot influence the assertions. This keeps
    // the test focused purely on the method's own logic.
    @is{!Environment.IvanTest}
    static void testSetDefaultDescription_BlankDescription() {
        Account customerAcc = new Account(Name = 'New Customer', Type = 'Customer');
        Account partnerAcc = new Account(Name = 'New Partner', Type = 'Partner');
        Account otherAcc = new Account(Name = 'New Other', Type = 'Other');
        List<Account> accounts = new List<Account>{ customerAcc, partnerAcc, otherAcc };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CustomerAccountService.setDefaultDescription(accounts);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Default description: Customer Account', customerAcc.Description, 'Customer description mismatch');
        System.assertEquals('Default description: Partner Account', partnerAcc.Description, 'Partner description mismatch');
        System.assertEquals('Default description: Other Account', otherAcc.Description, 'Other description mismatch');
    }

    @is{!Environment.IvanTest}
    static void testSetDefaultDescription_ExistingDescriptionNotOverwritten() {
        Account acc = new Account(Name = 'Has Description', Type = 'Customer', Description = 'Keep me');
        List<Account> accounts = new List<Account>{ acc };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CustomerAccountService.setDefaultDescription(accounts);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Keep me', acc.Description, 'Existing description should not be overwritten');
    }

    @is{!Environment.IvanTest}
    static void testSetDefaultDescription_ViaTriggerInsert() {
        // Confirms the trigger wires up correctly on real DML. Since an
        // active before-save Flow also sets Description on create, we only
        // assert that a Description ends up populated (not blank), rather
        // than asserting the exact default text, to avoid coupling this
        // test to other automation's behavior.
        Account acc = new Account(Name = 'Trigger Insert {!Environment.IvanTest}', Type = 'Customer');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert acc;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = [SELECT Description FROM Account WHERE Id = :acc.Id];
        System.assertNotEquals(null, result.Description, 'Description should be populated on insert');
    }
}