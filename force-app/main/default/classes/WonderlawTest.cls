@Is{!Environment.IvanTest}
private class Wonderlaw{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Account acc = new Account(Name = 'Setup Account', Industry = 'Technology');
        insert acc;
    }

    @Is{!Environment.IvanTest}
    static void testCreateAccount() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Account acc = Wonderlaw.createAccount('Wonderlaw {!Environment.IvanTest} Account');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, acc.Id, 'Account should have been inserted');
        System.assertEquals('Wonderlaw {!Environment.IvanTest} Account', acc.Name, 'Account name should match');
    }

    @Is{!Environment.IvanTest}
    static void testGetAllAccounts() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> accounts = Wonderlaw.getAllAccounts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(0, accounts.size(), 'Should return at least one account');
    }

    @Is{!Environment.IvanTest}
    static void testUpdateAccountIndustry() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Setup Account' LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Wonderlaw.updateAccountIndustry(acc.Id, 'Finance');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Account updated = [SELECT Industry FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Finance', updated.Industry, 'Industry should be updated to Finance');
    }

    @Is{!Environment.IvanTest}
    static void testDeleteAccount() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Setup Account' LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Wonderlaw.deleteAccount(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Account> remaining = [SELECT Id FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, remaining.size(), 'Account should have been deleted');
    }

    @Is{!Environment.IvanTest}
    static void testGetAllAccountsBulk() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Bulk Account ' + i));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert accounts;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Account> result = Wonderlaw.getAllAccounts();
        System.assert(result.size() >= 50, 'Should return at least 50 accounts');
    }
}