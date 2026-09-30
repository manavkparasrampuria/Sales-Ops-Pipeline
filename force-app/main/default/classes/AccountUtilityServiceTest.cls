@is{!Environment.IvanTest}
private class AccountUtilityService{!Environment.IvanTest} {

    private static Account buildAccount(String name, Decimal annualRevenue, String description) {
        return new Account(
            Name          = name,
            AnnualRevenue = annualRevenue,
            Description   = description,
            Phone         = '0000000000',
            Bypass__c     = true
        );
    }

    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(buildAccount('{!Environment.IvanTest} Account Alpha ' + i, i * 100000, 'Initial Description '));
        }
        insert accounts;

        insert new Contact(
            FirstName  = '{!Environment.IvanTest}',
            LastName   = 'Contact',
            AccountId  = accounts[0].Id,
            Department = 'Sales'
        );
    }

    @is{!Environment.IvanTest}
    static void testUpdateAccountDescriptions_Positive() {
        List<Account> accounts = [SELECT Id, Description FROM Account LIMIT 5];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountUtilityService.updateAccountDescriptions(accounts, ' - Updated');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Account> updated = [SELECT Id, Description FROM Account WHERE Id IN :accounts];
        for (Account acc : updated) {
            System.assert(acc.Description.contains(' - Updated'), 'Description should contain the suffix.');
        }
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_Hot() {
        Account acc = new Account(Name = 'Hot Account', AnnualRevenue = 2000000);
        List<Account> result = AccountUtilityService.applyRevenueRating(new List<Account>{ acc });
        System.assertEquals('Hot', result[0].Rating, 'Expected Hot rating for revenue >= 1,000,000.');
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_Warm() {
        Account acc = new Account(Name = 'Warm Account', AnnualRevenue = 750000);
        List<Account> result = AccountUtilityService.applyRevenueRating(new List<Account>{ acc });
        System.assertEquals('Warm', result[0].Rating, 'Expected Warm rating for revenue >= 500,000.');
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_Cold() {
        Account acc = new Account(Name = 'Cold Account', AnnualRevenue = 100000);
        List<Account> result = AccountUtilityService.applyRevenueRating(new List<Account>{ acc });
        System.assertEquals('Cold', result[0].Rating, 'Expected Cold rating for revenue < 500,000.');
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_NullRevenue() {
        Account acc = new Account(Name = 'Null Revenue Account');
        List<Account> result = AccountUtilityService.applyRevenueRating(new List<Account>{ acc });
        System.assertEquals('Cold', result[0].Rating, 'Expected Cold rating when AnnualRevenue is null.');
    }

    @is{!Environment.IvanTest}
    static void testGetAccountsWithNoContacts_Positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> result = AccountUtilityService.getAccountsWithNoContacts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(9, result.size(), 'Expected 9 accounts with no contacts.');
    }

    @is{!Environment.IvanTest}
    static void testUpdateAccountDescriptions_NullList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountUtilityService.updateAccountDescriptions(null, ' - Suffix');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'No exception should be thrown for null list.');
    }

    @is{!Environment.IvanTest}
    static void testUpdateAccountDescriptions_EmptyList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountUtilityService.updateAccountDescriptions(new List<Account>(), ' - Suffix');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'No exception should be thrown for empty list.');
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_NullList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> result = AccountUtilityService.applyRevenueRating(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Result should not be null.');
        System.assertEquals(0, result.size(), 'Result should be empty for null input.');
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_EmptyList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> result = AccountUtilityService.applyRevenueRating(new List<Account>());
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(0, result.size(), 'Result should be empty for empty input.');
    }

    @is{!Environment.IvanTest}
    static void testUpdateAccountDescriptions_Bulk() {
        List<Account> bulkAccounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            bulkAccounts.add(buildAccount('Bulk Account Alpha ' + i, null, 'Bulk '));
        }
        insert bulkAccounts;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountUtilityService.updateAccountDescriptions(bulkAccounts, 'BULK_SUFFIX');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Account> updated = [SELECT Id, Description FROM Account WHERE Name LIKE 'Bulk Account Alpha%'];
        for (Account acc : updated) {
            System.assert(acc.Description.contains('BULK_SUFFIX'), 'Bulk description should contain suffix.');
        }
    }

    @is{!Environment.IvanTest}
    static void testApplyRevenueRating_Bulk() {
        List<Account> bulkAccounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            bulkAccounts.add(new Account(Name = 'Rating Account Alpha ' + i, AnnualRevenue = i * 10000));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> result = AccountUtilityService.applyRevenueRating(bulkAccounts);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(200, result.size(), 'All 200 accounts should be rated.');
        for (Account acc : result) {
            System.assertNotEquals(null, acc.Rating, 'Every account should have a rating.');
        }
    }

    @is{!Environment.IvanTest}
    static void testContactTrigger_BeforeInsert_DefaultTitle() {
        Contact con = new Contact(FirstName = 'Insert', LastName = 'NoTitle');
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert con;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Contact inserted = [SELECT Id, Title FROM Contact WHERE Id = :con.Id];
        System.assertEquals('Team Member', inserted.Title, 'Title should default to Team Member on insert.');
    }

    @is{!Environment.IvanTest}
    static void testContactTrigger_BeforeInsert_TitlePreserved() {
        Contact con = new Contact(FirstName = 'Insert', LastName = 'WithTitle', Title = 'Manager');
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert con;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Contact inserted = [SELECT Id, Title FROM Contact WHERE Id = :con.Id];
        System.assertEquals('Manager', inserted.Title, 'Existing Title should not be overwritten on insert.');
    }

    @is{!Environment.IvanTest}
    static void testContactTrigger_BeforeUpdate_DepartmentChanged() {
        Contact con = [SELECT Id, Department, Description FROM Contact LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        con.Department = 'Engineering';
        update con;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Contact updated = [SELECT Id, Description FROM Contact WHERE Id = :con.Id];
        System.assert(
            updated.Description != null && updated.Description.contains('Department changed on:'),
            'Description should be stamped when Department changes.'
        );
    }

    @is{!Environment.IvanTest}
    static void testContactTrigger_BeforeUpdate_DepartmentUnchanged() {
        Contact con = [SELECT Id, Department, Description FROM Contact LIMIT 1];
        String originalDescription = con.Description;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        con.Title = 'Senior Manager';
        update con;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Contact updated = [SELECT Id, Description FROM Contact WHERE Id = :con.Id];
        System.assertEquals(originalDescription, updated.Description, 'Description should not change when Department is unchanged.');
    }
}