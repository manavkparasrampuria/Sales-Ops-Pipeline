/**
 * @description Utility class for Account-related operations.
 * @author      Copado Build Agent
 * @date        2026-08-16
 */
public with sharing class AccountUtex {

    /**
     * @description Returns the Name of an Account given its Id.
     *              Returns null if the Id is blank or no record is found.
     * @param  accountId  The Id of the Account to look up.
     * @return            The Account Name, or null if not found.
     */
    public static String getAccountName(Id accountId) {
        if (accountId == null) {
            return null;
        }

        List<Account> accounts = [
            SELECT Name
            FROM   Account
            WHERE  Id = :accountId
            LIMIT  1
        ];

        return accounts.isEmpty() ? null : accounts[0].Name;
    }
}