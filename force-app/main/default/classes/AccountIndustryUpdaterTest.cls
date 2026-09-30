/**
 * @description {!Environment.IvanTest} class for AccountIndustryUpdater.
 *              Covers positive bulk update, null input, empty set input,
 *              and clearing the Industry field (null industry value).
 *
 * @author      Copado Build Agent
 * @date        2026-08-31
 */
@Is{!Environment.IvanTest}
private class AccountIndustryUpdater{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Helpers ────────────────────────────────────────────────────

    /**
     * @description Creates and inserts a list of Account records using a
     *              caller-supplied name prefix to guarantee uniqueness across
     *              test methods (the duplicate-name trigger is active in tests).
     *
     * @param prefix  Unique prefix for Account names (e.g. 'Target', 'Bystander').
     * @param count   Number of Accounts to create.
     * @return        List of inserted Account records (with IDs populated).
     */
    private static List<Account> createAccounts(String prefix, Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(Name = prefix + ' Account ' + i));
        }
        insert accounts;
        return accounts;
    }

    // ─── Positive {!Environment.IvanTest}s ───────────────────────────────────────────────────────

    /**
     * @description Calling updateIndustry with a valid set of IDs and a
     *              recognised Industry value must update all matched records.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateIndustryBulkSuccess() {
        List<Account> accounts = createAccounts('Bulk', 5);
        Set<Id> ids = new Map<Id, Account>(accounts).keySet();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountIndustryUpdater.updateIndustry(ids, 'Technology');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        for (Account acc : [SELECT Industry FROM Account WHERE Id IN :ids]) {
            Assert.areEqual(
                'Technology',
                acc.Industry,
                'Industry should be updated to Technology.'
            );
        }
    }

    /**
     * @description Only the Accounts whose IDs are in the set must be updated;
     *              other Accounts must remain unchanged.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateIndustryOnlyTargetedRecords() {
        List<Account> targets    = createAccounts('Target', 3);
        List<Account> bystanders = createAccounts('Bystander', 2);

        Set<Id> targetIds    = new Map<Id, Account>(targets).keySet();
        Set<Id> bystanderIds = new Map<Id, Account>(bystanders).keySet();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountIndustryUpdater.updateIndustry(targetIds, 'Finance');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        for (Account acc : [SELECT Industry FROM Account WHERE Id IN :targetIds]) {
            Assert.areEqual('Finance', acc.Industry, 'Target Industry should be Finance.');
        }

        for (Account acc : [SELECT Industry FROM Account WHERE Id IN :bystanderIds]) {
            Assert.areNotEqual('Finance', acc.Industry, 'Bystander Industry should not be Finance.');
        }
    }

    /**
     * @description Passing a null industry value must clear the Industry field
     *              on all matched records.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateIndustryClearsFieldWhenNull() {
        List<Account> accounts = createAccounts('Clear', 2);
        for (Account acc : accounts) {
            acc.Industry = 'Education';
        }
        update accounts;

        Set<Id> ids = new Map<Id, Account>(accounts).keySet();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AccountIndustryUpdater.updateIndustry(ids, null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        for (Account acc : [SELECT Industry FROM Account WHERE Id IN :ids]) {
            Assert.isNull(acc.Industry, 'Industry should be cleared (null).');
        }
    }

    // ─── Negative / Edge-Case {!Environment.IvanTest}s ───────────────────────────────────────────

    /**
     * @description Passing a null set must return without throwing an exception
     *              and must not perform any DML.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateIndustryNullSetIsNoOp() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AccountIndustryUpdater.updateIndustry(null, 'Technology');
        } catch (Exception e) {
            Assert.fail('No exception expected for null accountIds. Got: ' + e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    /**
     * @description Passing an empty set must return without throwing an exception
     *              and must not perform any DML.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateIndustryEmptySetIsNoOp() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AccountIndustryUpdater.updateIndustry(new Set<Id>(), 'Technology');
        } catch (Exception e) {
            Assert.fail('No exception expected for empty accountIds. Got: ' + e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    /**
     * @description Passing IDs that do not match any Account must complete
     *              without error and perform no DML.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateIndustryNonExistentIdsIsNoOp() {
        Set<Id> fakeIds = new Set<Id>{ '001000000000001AAA' };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AccountIndustryUpdater.updateIndustry(fakeIds, 'Technology');
        } catch (Exception e) {
            Assert.fail('No exception expected for non-existent IDs. Got: ' + e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}