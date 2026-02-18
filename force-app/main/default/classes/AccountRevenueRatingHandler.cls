/**
 * @description US-001: Update Account Rating based on Annual Revenue
 * @author Developer A
 * @date 2026-02-18
 */
public with sharing class AccountRevenueRatingHandler {
    
    /**
     * @description Update Account Rating based on Annual Revenue
     * @param accountIds Set of Account IDs to process
     */
    public static void updateRating(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds]) {
            String rating = calculateRatingByRevenue(acc.AnnualRevenue);
            accountsToUpdate.add(new Account(Id = acc.Id, Rating = rating));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    /**
     * @description Calculate rating based on annual revenue
     * @param revenue Annual Revenue amount
     * @return Rating value
     */
    @TestVisible
    private static String calculateRatingByRevenue(Decimal revenue) {
        if (revenue == null || revenue < 100000) {
            return 'Cold';
        } else if (revenue < 500000) {
            return 'Warm';
        } else {
            return 'Hot';
        }
    }
}