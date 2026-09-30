/**
 * {!Environment.IvanTest} class for AccountRandomNameGenerator.
 */
@is{!Environment.IvanTest}
private class AccountRandomNameGenerator{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Original Name ' + i));
        }
        insert accounts;
    }

    @is{!Environment.IvanTest}
    static void testGenerateRandomNames_bulkUpdatesAllAccounts() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        List<Id> accountIds = new List<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountRandomNameGenerator.generateRandomNames(accountIds);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Account> updatedAccounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        System.assertEquals(200, updatedAccounts.size(), 'All 200 accounts should be returned');
        for (Integer i = 0; i < updatedAccounts.size(); i++) {
            System.assertNotEquals('Original Name ' + i, updatedAccounts[i].Name,
                'Account name should have been replaced with a random name');
            System.assert(String.isNotBlank(updatedAccounts[i].Name), 'Generated name should not be blank');
        }
    }

    @is{!Environment.IvanTest}
    static void testGenerateRandomNames_emptyListDoesNothing() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountRandomNameGenerator.generateRandomNames(new List<Id>());
        AccountRandomNameGenerator.generateRandomNames(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Account> accounts = [SELECT Id, Name FROM Account];
        for (Integer i = 0; i < accounts.size(); i++) {
            System.assert(accounts[i].Name.startsWith('Original Name'),
                'Names should remain unchanged when no Ids are provided');
        }
    }

    @is{!Environment.IvanTest}
    static void testGenerateRandomName_returnsNonBlankValue() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String randomName = AccountRandomNameGenerator.generateRandomName();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(String.isNotBlank(randomName), 'Generated name should not be blank');
        System.assert(randomName.contains(' '), 'Generated name should contain multiple parts');
    }
}