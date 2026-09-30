public with sharing class BudgetTriggerHandler {

    /**
     * Recalculates Total_Income__c and Total_Expenses__c on HomeBudget__c
     * whenever BudgetItem__c records are inserted, updated, or deleted.
     */
    public static void recalculateBudgetTotals(List<BudgetItem__c> newItems, List<BudgetItem__c> oldItems) {
        Set<Id> budgetIds = new Set<Id>();

        if (newItems != null) {
            for (BudgetItem__c item : newItems) {
                if (item.HomeBudget__c != null) {
                    budgetIds.add(item.HomeBudget__c);
                }
            }
        }

        if (oldItems != null) {
            for (BudgetItem__c item : oldItems) {
                if (item.HomeBudget__c != null) {
                    budgetIds.add(item.HomeBudget__c);
                }
            }
        }

        if (budgetIds.isEmpty()) {
            return;
        }

        Map<Id, HomeBudget__c> budgetMap = new Map<Id, HomeBudget__c>([
            SELECT Id, Total_Income__c, Total_Expenses__c
            FROM HomeBudget__c
            WHERE Id IN :budgetIds
        ]);

        Map<Id, Decimal> incomeMap   = new Map<Id, Decimal>();
        Map<Id, Decimal> expenseMap  = new Map<Id, Decimal>();

        for (Id bId : budgetIds) {
            incomeMap.put(bId, 0);
            expenseMap.put(bId, 0);
        }

        for (AggregateResult ar : [
            SELECT HomeBudget__c budgetId,
                   Type__c       itemType,
                   SUM(Amount__c) total
            FROM   BudgetItem__c
            WHERE  HomeBudget__c IN :budgetIds
            GROUP BY HomeBudget__c, Type__c
        ]) {
            Id     bId   = (Id)     ar.get('budgetId');
            String iType = (String) ar.get('itemType');
            Decimal tot  = (Decimal) ar.get('total');

            if (iType == 'Income') {
                incomeMap.put(bId, tot);
            } else if (iType == 'Expense') {
                expenseMap.put(bId, tot);
            }
        }

        List<HomeBudget__c> toUpdate = new List<HomeBudget__c>();
        for (Id bId : budgetIds) {
            HomeBudget__c hb = budgetMap.get(bId);
            if (hb != null) {
                hb.Total_Income__c   = incomeMap.get(bId);
                hb.Total_Expenses__c = expenseMap.get(bId);
                toUpdate.add(hb);
            }
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    /**
     * Validates that a BudgetItem Amount is greater than zero.
     */
    public static void validateAmounts(List<BudgetItem__c> items) {
        for (BudgetItem__c item : items) {
            if (item.Amount__c == null || item.Amount__c <= 0) {
                item.Amount__c.addError('Amount must be greater than zero.');
            }
        }
    }

    /**
     * Auto-populates the Description field with a default value when blank.
     */
    public static void setDefaultDescription(List<BudgetItem__c> items) {
        for (BudgetItem__c item : items) {
            if (String.isBlank(item.Description__c)) {
                item.Description__c = item.Type__c + ' - ' + (item.Category__c != null ? item.Category__c : 'General');
            }
        }
    }
}