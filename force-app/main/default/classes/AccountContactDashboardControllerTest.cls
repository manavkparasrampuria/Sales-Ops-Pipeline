@Is{!Environment.IvanTest}
private class AccountContactDashboardController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        Account testAccount = new Account(Name = '{!Environment.IvanTest} Account Dashboard');
        insert testAccount;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= 10; i++) {
            contacts.add(new Contact(
                FirstName = '{!Environment.IvanTest}', LastName = 'Contact ' + i,
                Email = 'testcontact' + i + '@example.com',
                Phone = '555-000' + i, AccountId = testAccount.Id
            ));
        }
        insert contacts;
    }

    @Is{!Environment.IvanTest}
    static void testGetAccountContacts_returnsContacts() {
        Account acc = [SELECT Id FROM Account WHERE Name = '{!Environment.IvanTest} Account Dashboard' LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = AccountContactDashboardController.getAccountContacts(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(10, result.size(), 'Should return 10 contacts');
    }

    @Is{!Environment.IvanTest}
    static void testGetAccountContacts_noContacts() {
        Account emptyAccount = new Account(Name = 'Empty Account');
        insert emptyAccount;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = AccountContactDashboardController.getAccountContacts(emptyAccount.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.size(), 'Should return 0 contacts');
    }

    @Is{!Environment.IvanTest}
    static void testGetAccountContacts_nullAccountId() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AccountContactDashboardController.getAccountContacts(null);
            System.assert(false, 'Expected AuraHandledException not thrown');
        } catch (AuraHandledException e) {
            System.assertNotEquals(null, e.getMessage(), 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}