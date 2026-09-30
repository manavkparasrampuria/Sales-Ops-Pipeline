/**
 * @description Unit tests for AccountUtex.
 * @author      Copado Build Agent
 * @date        2026-08-16
 */
@Is{!Environment.IvanTest}
private class AccountUtex{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void makeData() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account Utex');
        insert acc;
    }

    @Is{!Environment.IvanTest}
    static void testGetAccountName_ValidId_ReturnsName() {
        Account acc = [SELECT Id FROM Account WHERE Name = '{!Environment.IvanTest} Account Utex' LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = AccountUtex.getAccountName(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.areEqual('{!Environment.IvanTest} Account Utex', result, 'Expected the Account Name to match.');
    }

    @Is{!Environment.IvanTest}
    static void testGetAccountName_NullId_ReturnsNull() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = AccountUtex.getAccountName(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.isNull(result, 'Expected null when accountId is null.');
    }

    @Is{!Environment.IvanTest}
    static void testGetAccountName_NonExistentId_ReturnsNull() {
        Id fakeId = '001000000000001AAA';
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = AccountUtex.getAccountName(fakeId);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Assert.isNull(result, 'Expected null for a non-existent Account Id.');
    }
}