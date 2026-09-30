/**
 * @description {!Environment.IvanTest} class for AccountTriggerHandler.
 *              Covers duplicate-name prevention on both insert and update,
 *              as well as positive (non-duplicate) flows.
 *
 * @author      Copado Build Agent
 * @date        2026-08-26
 */
@Is{!Environment.IvanTest}
private class AccountTriggerHandler{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Setup ───────────────────────────────────────────────────────

    /**
     * @description Creates and inserts a seed Account used across tests.
     *              Kept in a helper rather than @{!Environment.IvanTest}Setup so each test
     *              method gets an isolated context.
     *
     * @param name  The Account name to insert.
     * @return      The inserted Account record.
     */
    private static Account createAndInsertAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    // ─── Insert {!Environment.IvanTest}s ──────────────────────────────────────────────────────────

    /**
     * @description Inserting an Account with a unique name must succeed.
     */
    @Is{!Environment.IvanTest}
    static void testInsertUniqueNameSucceeds() {
        Account acc = new Account(Name = 'Unique Corp');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert acc;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Account> result = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];
        Assert.isFalse(result.isEmpty(), 'Account should have been inserted successfully.');
        Assert.areEqual('Unique Corp', result[0].Name, 'Account name should match.');
    }

    /**
     * @description Inserting an Account with an exact duplicate name must fail.
     */
    @Is{!Environment.IvanTest}
    static void testInsertExactDuplicateNameFails() {
        createAndInsertAccount('Duplicate Corp');

        Account duplicate = new Account(Name = 'Duplicate Corp');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert duplicate;
            Assert.fail('Expected a DmlException for duplicate Account name.');
        } catch (DmlException e) {
            Assert.isTrue(
                e.getMessage().contains('already exists'),
                'Error message should indicate the Account already exists.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    /**
     * @description Inserting an Account with a case-different duplicate name
     *              (e.g., "DUPLICATE CORP" vs "Duplicate Corp") must also fail.
     */
    @Is{!Environment.IvanTest}
    static void testInsertCaseInsensitiveDuplicateNameFails() {
        createAndInsertAccount('Case Corp');

        Account duplicate = new Account(Name = 'CASE CORP');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert duplicate;
            Assert.fail('Expected a DmlException for case-insensitive duplicate Account name.');
        } catch (DmlException e) {
            Assert.isTrue(
                e.getMessage().contains('already exists'),
                'Error message should indicate the Account already exists.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    /**
     * @description Bulk insert with a mix of unique and duplicate names
     *              must fail gracefully, erroring only the duplicate records.
     */
    @Is{!Environment.IvanTest}
    static void testBulkInsertPartialDuplicateFails() {
        createAndInsertAccount('Bulk Existing Corp');

        List<Account> batch = new List<Account>{
            new Account(Name = 'Brand New Corp'),
            new Account(Name = 'Bulk Existing Corp')
        };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Database.SaveResult[] results = Database.insert(batch, false);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Assert.isTrue(results[0].isSuccess(),  'First record (unique) should succeed.');
        Assert.isFalse(results[1].isSuccess(), 'Second record (duplicate) should fail.');
        Assert.isTrue(
            results[1].getErrors()[0].getMessage().contains('already exists'),
            'Error message should mention the duplicate name.'
        );
    }

    // ─── Update {!Environment.IvanTest}s ──────────────────────────────────────────────────────────

    /**
     * @description Updating an Account to a name already used by another
     *              Account must be prevented.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateToDuplicateNameFails() {
        createAndInsertAccount('Existing Account');
        Account toUpdate = createAndInsertAccount('Account To Rename');

        toUpdate.Name = 'Existing Account';

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            update toUpdate;
            Assert.fail('Expected a DmlException when renaming to an existing Account name.');
        } catch (DmlException e) {
            Assert.isTrue(
                e.getMessage().contains('already exists'),
                'Error message should indicate the Account already exists.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    /**
     * @description Updating an Account without changing its name must succeed
     *              (no false-positive duplicate error against itself).
     */
    @Is{!Environment.IvanTest}
    static void testUpdateSameNameSucceeds() {
        Account acc = createAndInsertAccount('Self Update Corp');
        acc.Description = 'Updated description';

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update acc;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = [SELECT Description FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('Updated description', result.Description, 'Description should be updated.');
    }

    /**
     * @description Updating an Account to a genuinely new, unique name must succeed.
     */
    @Is{!Environment.IvanTest}
    static void testUpdateToUniqueNameSucceeds() {
        Account acc = createAndInsertAccount('Old Name Corp');
        acc.Name = 'Completely New Name Corp';

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update acc;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = [SELECT Name FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('Completely New Name Corp', result.Name, 'Name should be updated.');
    }
}