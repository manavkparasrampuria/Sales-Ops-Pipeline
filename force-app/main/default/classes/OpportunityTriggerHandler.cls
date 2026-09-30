/**
 * @description Handler class for OpportunityTrigger.
 *              Recalculates and updates LoyaltyPoints__c on parent Accounts
 *              whenever Opportunities are inserted or updated.
 *              Loyalty points = 1 point per $1,000 of Closed Won revenue.
 *              Also orchestrates the Closed Won -> Contract -> Subscription
 *              lifecycle automation.
 *              Prevents stage regression from Closed Won to any earlier stage.
 *
 * @author      Copado Orchestrate Agent
 * @date        2026-08-13
 * @modified    2026-09-08  Added preventStageRegression()
 */
public with sharing class OpportunityTriggerHandler {

    // Points awarded per unit of revenue
    private static final Decimal POINTS_PER_UNIT = 1000;

    // The stage that must never be regressed from
    private static final String CLOSED_WON = 'Closed Won';

    // Error message surfaced to the user on a regression attempt
    @{!Environment.IvanTest}Visible
    private static final String REGRESSION_ERROR =
        'Stage cannot be changed from Closed Won to an earlier stage.';

    // ─── Public Entry Points ───────────────────────────────────────────────

    /**
     * @description Entry point called by OpportunityTrigger (after context).
     * @param newList  Trigger.new list of Opportunity records.
     * @param oldMap   Trigger.oldMap keyed by Opportunity Id (null on insert).
     */
    public static void handle(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        Set<Id> accountIds = getRelevantAccountIds(newList, oldMap);
        if (!accountIds.isEmpty()) {
            Map<Id, Decimal> pointsByAccount = calculatePoints(accountIds);
            updateAccounts(pointsByAccount);
        }
        OpportunityLifecycleOrchestrator.processClosedWon(newList, oldMap);
    }

    /**
     * @description Prevents an Opportunity from being moved out of Closed Won
     *              to any other stage. Called in the before-update context so
     *              addError() blocks the DML without a try/catch.
     *
     *              Bulkification: iterates Trigger.new once; no SOQL or DML.
     *
     * @param newList  Trigger.new list of Opportunity records being updated.
     * @param oldMap   Trigger.oldMap keyed by Opportunity Id.
     */
    public static void preventStageRegression(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            if (oldOpp.StageName == CLOSED_WON && opp.StageName != CLOSED_WON) {
                opp.StageName.addError(REGRESSION_ERROR);
            }
        }
    }

    // ─── Private Helpers ──────────────────────────────────────────────────

    /**
     * @description Identifies Account Ids that need recalculation.
     *              Only processes records where StageName changed to/from
     *              'Closed Won', or where Amount changed on a Closed Won opp,
     *              or on insert when the opp is already Closed Won.
     */
    private static Set<Id> getRelevantAccountIds(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newList) {
            if (opp.AccountId == null) {
                continue;
            }
            Boolean isInsert = (oldMap == null);
            if (isInsert) {
                if (opp.StageName == CLOSED_WON) {
                    accountIds.add(opp.AccountId);
                }
            } else {
                Opportunity oldOpp = oldMap.get(opp.Id);
                Boolean stageChanged  = (opp.StageName != oldOpp.StageName);
                Boolean amountChanged = (opp.Amount    != oldOpp.Amount);
                Boolean isClosedWon   = (opp.StageName == CLOSED_WON);
                Boolean wasClosedWon  = (oldOpp.StageName == CLOSED_WON);
                if (stageChanged || (isClosedWon && amountChanged) || wasClosedWon) {
                    accountIds.add(opp.AccountId);
                }
            }
        }
        return accountIds;
    }

    /**
     * @description Aggregates total Closed Won Amount per Account and
     *              converts to loyalty points (1 pt per $1,000).
     * @param accountIds Set of Account Ids to recalculate.
     * @return Map of Account Id to calculated loyalty points.
     */
    private static Map<Id, Decimal> calculatePoints(Set<Id> accountIds) {
        Map<Id, Decimal> pointsByAccount = new Map<Id, Decimal>();
        // Initialise all accounts to 0 so accounts with no Closed Won opps
        // are still updated (resetting any stale value).
        for (Id accId : accountIds) {
            pointsByAccount.put(accId, 0);
        }
        for (AggregateResult ar : [
            SELECT AccountId, SUM(Amount) totalAmount
            FROM   Opportunity
            WHERE  AccountId IN :accountIds
            AND    StageName  = 'Closed Won'
            AND    IsDeleted  = false
            WITH   SECURITY_ENFORCED
            GROUP BY AccountId
        ]) {
            Id      accId       = (Id)      ar.get('AccountId');
            Decimal totalAmount = (Decimal) ar.get('totalAmount');
            if (totalAmount == null) {
                totalAmount = 0;
            }
            pointsByAccount.put(accId, (totalAmount / POINTS_PER_UNIT).round(System.RoundingMode.DOWN));
        }
        return pointsByAccount;
    }

    /**
     * @description Performs a bulkified DML update on Account records.
     * @param pointsByAccount Map of Account Id to new loyalty points value.
     */
    private static void updateAccounts(Map<Id, Decimal> pointsByAccount) {
        List<Account> toUpdate = new List<Account>();
        for (Id accId : pointsByAccount.keySet()) {
            toUpdate.add(new Account(
                Id              = accId,
                LoyaltyPoints__c = pointsByAccount.get(accId)
            ));
        }
        if (!toUpdate.isEmpty()) {
            // CRUD check: only update if the running user has edit access
            if (Schema.sObjectType.Account.isUpdateable()) {
                update toUpdate;
            }
        }
    }
}