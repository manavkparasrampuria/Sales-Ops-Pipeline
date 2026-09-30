/**
 * @description Simple helper class to verify test execution
 */
public with sharing class AccountHelper {
    
    /**
     * @description Creates a list of accounts
     * @param numberOfAccounts Number of accounts to create
     * @param accountName Base name for the accounts
     * @return List of Account records (not inserted)
     */
    public static List<Account> createAccounts(Integer numberOfAccounts, String accountName) {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(
                Name = accountName + ' ' + i,
                Industry = 'Technology',
                Type = 'Prospect'
            );
            accounts.add(acc);
        }
        
        return accounts;
    }
    
    /**
     * @description Gets the count of accounts with a specific industry
     * @param industry Industry to filter by
     * @return Integer count of accounts
     */
    public static Integer getAccountCountByIndustry(String industry) {
        return [
            SELECT COUNT() 
            FROM Account 
            WHERE Industry = :industry
            LIMIT 50000
        ];
    }
    
    /**
     * @description Updates account rating based on annual revenue
     * @param accountIds Set of account IDs to update
     */
    public static void updateAccountRatings(Set<Id> accountIds) {
        List<Account> accountsToUpdate = [
            SELECT Id, AnnualRevenue, Rating
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : accountsToUpdate) {
            if (acc.AnnualRevenue != null) {
                if (acc.AnnualRevenue >= 1000000) {
                    acc.Rating = 'Hot';
                } else if (acc.AnnualRevenue >= 500000) {
                    acc.Rating = 'Warm';
                } else {
                    acc.Rating = 'Cold';
                }
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}