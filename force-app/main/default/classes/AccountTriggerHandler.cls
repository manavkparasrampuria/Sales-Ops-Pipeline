/**
 * @description Handler class for AccountTrigger.
 *              Prevents duplicate Account names on insert and update,
 *              and synchronises the Industry field on after update
 *              by delegating to AccountIndustryUpdater.
 *
 * @author      Copado Build Agent
 * @date        2026-08-31
 */
public with sharing class AccountTriggerHandler {

    // ─── Recursion / Re-entry Guards ────────────────────────────────────────
    // Other automations on Account (CustomerAccountTrigger, before-save Flows,
    // and AccountIndustryUpdater's own DML) can cause this trigger to re-enter
    // within the same transaction, once per chained DML statement. Tracking
    // Ids already processed here keeps each record's duplicate-name check and
    // Industry sync to a single execution per transaction, instead of
    // re-issuing the bulk SOQL query on every re-entry.
    private static Set<Id> duplicateNameCheckedIds = new Set<Id>();
    private static Set<Id> industrySyncedIds = new Set<Id>();

    // ─── Public Entry Point ─────────────────────────────────────────────────

    /**
     * @description Entry point called by AccountTrigger.
     *              Delegates to context-specific methods based on the
     *              trigger operation that is currently running.
     *
     * @param newList    Trigger.new  - records in the current transaction.
     * @param oldMap     Trigger.oldMap - previous values (null on insert).
     * @param operation  Trigger.operationType for context routing.
     */
    public static void handle(
        List<Account>    newList,
        Map<Id, Account> oldMap,
        System.TriggerOperation operation
    ) {
        switch on operation {
            when BEFORE_INSERT {
                preventDuplicateNames(newList, null);
            }
            when BEFORE_UPDATE {
                preventDuplicateNames(newList, oldMap);
            }
            when AFTER_UPDATE {
                syncIndustryOnChange(newList, oldMap);
            }
        }
    }

    // ─── Private Helpers ────────────────────────────────────────────────────

    /**
     * @description Detects duplicate Account names and surfaces an error
     *              directly on the Name field so Salesforce prevents the save.
     *              Case-insensitive comparison is handled by normalising both
     *              sides to lower-case in Apex after a single bulkified query.
     *
     *              Bulkification strategy:
     *              1. Skip records already validated earlier in this
     *                 transaction (recursion guard against chained DML from
     *                 other Account automations).
     *              2. Collect the names of the remaining records being processed.
     *              3. Issue a single SOQL query for existing Accounts,
     *                 excluding the records themselves on update.
     *              4. Iterate the remaining records once to flag any conflicts.
     *
     * @param newList  Trigger.new list.
     * @param oldMap   Trigger.oldMap (null on insert).
     */
    private static void preventDuplicateNames(
        List<Account>    newList,
        Map<Id, Account> oldMap
    ) {
        Boolean isUpdate = (oldMap != null);

        Set<String>   namesToCheck      = new Set<String>();
        List<Account> recordsToEvaluate = new List<Account>();

        for (Account acc : newList) {
            // Recursion guard: on update, skip records this transaction has
            // already validated (e.g. re-entry triggered by a chained DML
            // from another Account automation).
            if (isUpdate && acc.Id != null && duplicateNameCheckedIds.contains(acc.Id)) {
                continue;
            }
            if (String.isBlank(acc.Name)) {
                continue;
            }
            if (isUpdate) {
                Account oldAcc = oldMap.get(acc.Id);
                if (acc.Name.equalsIgnoreCase(oldAcc.Name)) {
                    continue;
                }
            }
            namesToCheck.add(acc.Name.trim().toLowerCase());
            recordsToEvaluate.add(acc);
        }

        if (namesToCheck.isEmpty()) {
            return;
        }

        Set<Id>     currentIds    = (isUpdate) ? oldMap.keySet() : new Set<Id>();
        Set<String> existingNames = new Set<String>();

        for (Account existing : [
            SELECT Name
            FROM   Account
            WHERE  Id NOT IN :currentIds
            WITH   USER_MODE
            LIMIT  50000
        ]) {
            if (String.isNotBlank(existing.Name)) {
                existingNames.add(existing.Name.trim().toLowerCase());
            }
        }

        for (Account acc : recordsToEvaluate) {
            String normalised = acc.Name.trim().toLowerCase();
            if (existingNames.contains(normalised)) {
                acc.Name.addError(
                    'An Account with the name "' + acc.Name + '" already exists. ' +
                    'Please use a unique Account name.'
                );
            }
            if (isUpdate && acc.Id != null) {
                duplicateNameCheckedIds.add(acc.Id);
            }
        }
    }

    /**
     * @description Detects Accounts whose Industry field changed during an
     *              update and delegates the re-sync to AccountIndustryUpdater.
     *              Only records with an actual Industry change are included,
     *              keeping the DML footprint minimal.
     *
     *              A recursion guard prevents the same record from being
     *              re-synced (and re-querying/re-updating via
     *              AccountIndustryUpdater) more than once per transaction,
     *              which would otherwise happen if another Account automation
     *              chains a further update DML within the same transaction.
     *
     * @param newList  Trigger.new list (after-update context).
     * @param oldMap   Trigger.oldMap with pre-update values.
     */
    private static void syncIndustryOnChange(
        List<Account>    newList,
        Map<Id, Account> oldMap
    ) {
        Set<Id> changedIds = new Set<Id>();

        for (Account acc : newList) {
            if (industrySyncedIds.contains(acc.Id)) {
                continue;
            }
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.Industry != oldAcc.Industry) {
                changedIds.add(acc.Id);
            }
        }

        if (!changedIds.isEmpty()) {
            String newIndustry = newList[0].Industry;
            AccountIndustryUpdater.updateIndustry(changedIds, newIndustry);
            industrySyncedIds.addAll(changedIds);
        }
    }
}