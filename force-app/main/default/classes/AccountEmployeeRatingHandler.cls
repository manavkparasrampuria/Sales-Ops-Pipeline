/**
 * @description US-002: Update Account Rating based on Number of Employees
 * @author Developer B
 * @date 2026-02-18
 */
public with sharing class AccountEmployeeRatingHandler {
    
    /**
     * @description Update Account Rating based on Number of Employees
     * @param accountIds Set of Account IDs to process
     */
    public static void updateRating(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : [SELECT Id, NumberOfEmployees FROM Account WHERE Id IN :accountIds]) {
            String rating = calculateRatingByEmployees(acc.NumberOfEmployees);
            accountsToUpdate.add(new Account(Id = acc.Id, Rating = rating));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    /**
     * @description Calculate rating based on employee count
     * @param employees Number of employees
     * @return Rating value
     */
    @TestVisible
    private static String calculateRatingByEmployees(Integer employees) {
        if (employees == null || employees < 50) {
            return 'Cold';
        } else if (employees < 200) {
            return 'Warm';
        } else {
            return 'Hot';
        }
    }
}