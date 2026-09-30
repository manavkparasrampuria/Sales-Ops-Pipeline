public with sharing class Wonderlaw {

    /**
     * Creates and persists a new Account record with the specified name.
     * @param accountName The name to assign to the new Account.
     * @return The newly inserted Account record.
     */
    public static Account createAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc;
    }

    /**
     * Retrieves all Account records from the database, ordered alphabetically by Name.
     * @return A list of Account records including Id, Name, Industry, and Phone fields.
     */
    public static List<Account> getAllAccounts() {
        return [SELECT Id, Name, Industry, Phone FROM Account ORDER BY Name];
    }

    /**
     * Updates the Industry field of an existing Account record.
     * @param accountId The Id of the Account to update.
     * @param industry The new Industry value to set on the Account.
     */
    public static void updateAccountIndustry(Id accountId, String industry) {
        Account acc = new Account(Id = accountId, Industry = industry);
        update acc;
    }

    /**
     * Deletes an existing Account record from the database by its Id.
     * @param accountId The Id of the Account record to delete.
     */
    public static void deleteAccount(Id accountId) {
        Account acc = new Account(Id = accountId);
        delete acc;
    }
}