/**
 * US-001: Update Account Rating based on Annual Revenue
 * Uses standard Account.Rating field
 */
public with sharing class AccountRevenueRatingHandler {
    
    public static void updateRating(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds]) {
            String newRating = getRatingFromRevenue(acc.AnnualRevenue);
            accountsToUpdate.add(new Account(Id = acc.Id, Rating = newRating));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    @TestVisible
    private static String getRatingFromRevenue(Decimal revenue) {
        if (revenue == null || revenue < 100000) {
            return 'Cold';
        } else if (revenue >= 500000) {
            return 'Hot';
        } else {
            return 'Warm';
        }
    }
}