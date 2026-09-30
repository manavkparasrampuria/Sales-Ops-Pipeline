public with sharing class AccountUtilityService {

    /**
     * Bulkified method to update Account descriptions by appending a given suffix.
     * Performs DML internally.
     */
    public static void updateAccountDescriptions(List<Account> accounts, String suffix) {
        if (accounts == null || accounts.isEmpty()) {
            return;
        }
        List<Account> toUpdate = new List<Account>();
        for (Account acc : accounts) {
            acc.Description = (acc.Description != null ? acc.Description : '') + suffix;
            toUpdate.add(acc);
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    /**
     * Bulkified method to apply a revenue-based rating to Accounts.
     * No DML performed - caller is responsible for saving.
     */
    public static List<Account> applyRevenueRating(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return new List<Account>();
        }
        for (Account acc : accounts) {
            if (acc.AnnualRevenue == null) {
                acc.Rating = 'Cold';
            } else if (acc.AnnualRevenue >= 1000000) {
                acc.Rating = 'Hot';
            } else if (acc.AnnualRevenue >= 500000) {
                acc.Rating = 'Warm';
            } else {
                acc.Rating = 'Cold';
            }
        }
        return accounts;
    }

    /**
     * Returns Accounts that have no associated Contacts.
     * The class is declared with sharing, so sharing rules are enforced automatically.
     */
    public static List<Account> getAccountsWithNoContacts() {
        return [
            SELECT Id, Name, Description, AnnualRevenue
            FROM Account
            WHERE Id NOT IN (
                SELECT AccountId FROM Contact WHERE AccountId != null
            )
        ];
    }
}