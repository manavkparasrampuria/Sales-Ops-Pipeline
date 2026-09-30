/**
 * @description Service class responsible for bulk-updating the Industry field
 *              on a specified set of Account records.
 *
 *              Design decisions:
 *              - Declared with sharing to respect org sharing rules.
 *              - Single public static method keeps the API surface minimal.
 *              - One SOQL query + one DML statement regardless of set size
 *                (fully bulkified, governor-limit safe).
 *              - Null / empty guard at the top prevents unnecessary work.
 *
 * @author      Copado Build Agent
 * @date        2026-08-31
 */
public with sharing class AccountIndustryUpdater {

    // ─── Public API ───────────────────────────────────────────────────────────

    /**
     * @description Updates the Industry picklist field on all Accounts whose
     *              IDs are contained in the provided set.
     *
     * @param accountIds  Set of Account record IDs to update. Null or empty
     *                    sets are handled gracefully (no-op).
     * @param industry    Target Industry picklist value to assign. Passing null
     *                    clears the field on all matched records.
     */
    public static void updateIndustry(Set<Id> accountIds, String industry) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : [
            SELECT Id, Industry
            FROM   Account
            WHERE  Id IN :accountIds
            WITH   USER_MODE
        ]) {
            acc.Industry = industry;
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update as user accountsToUpdate;
        }
    }
}