/**
 * US-002: Update Account Rating based on Number of Employees
 * Uses standard Account.Rating field
 */
public with sharing class AccountEmployeeRatingHandler {
    
    public static void updateRating(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : [SELECT Id, NumberOfEmployees FROM Account WHERE Id IN :accountIds]) {
            String newRating = getRatingFromEmployees(acc.NumberOfEmployees);
            accountsToUpdate.add(new Account(Id = acc.Id, Rating = newRating));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    @{!Environment.IvanTest}Visible
    private static String getRatingFromEmployees(Integer employees) {
        if (employees == null || employees < 60) {
            return 'Cold';
        } else if (employees >= 1250) {
            return 'Hot';
        } else {
            return 'Warm';
        }
    }
}
