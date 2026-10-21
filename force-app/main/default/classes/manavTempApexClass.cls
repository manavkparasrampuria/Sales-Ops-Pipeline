/**
 * @description Example Apex class for the Agentia local development flow (US-0000675).
 *              Demonstrates a bulkified, security-aware pattern: SOQL with
 *              USER_MODE, a single DML statement, and basic error handling.
 */
public with sharing class manavTempApexClass {
    /**
     * @description Returns accounts whose names start with the given prefix.
     * @param namePrefix The prefix to search for. Must not be blank.
     * @return List of matching Account records (max 50).
     */
    public static List<Account> getAccountsByNamePrefix(String namePrefix) {
        if (String.isBlank(namePrefix)) {
            throw new IllegalArgumentException('namePrefix must not be blank');
        }
        String likeValue = namePrefix + '%';
        return [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Name LIKE :likeValue
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }

    /**
     * @description Sets the Description field on the given accounts in bulk.
     * @param accountIds The Ids of the accounts to update.
     * @param description The text to write to the Description field.
     * @return Number of accounts updated.
     */
    public static Integer updateAccountDescriptions(Set<Id> accountIds, String description) {
        if (accountIds == null || accountIds.isEmpty()) {
            return 0;
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : [
            SELECT Id, Description
            FROM Account
            WHERE Id IN :accountIds
            WITH USER_MODE
        ]) {
            acc.Description = description;
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            Database.update(accountsToUpdate, AccessLevel.USER_MODE);
        }
        return accountsToUpdate.size();
    }
}