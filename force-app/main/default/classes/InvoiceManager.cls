/**
 * InvoiceManager
 * Utility class to manage Account records as a proxy for invoice-like operations.
 *
 * Copado User Story Usage:
 *  - User Story 1: Operation = Deploy  (pushes class to org)
 *  - User Story 2: Operation = Retrieve (pulls class back from org to Git)
 *
 * No custom object or custom field setup required.
 * Uses standard Account object straight out of the box.
 */
public with sharing class InvoiceManager {

    /**
     * Creates a new Account record simulating an invoice entry.
     * @param invoiceName - Name of the account/invoice
     * @param industry    - Industry category (used as invoice type proxy)
     * @return Inserted Account record
     */
    public static Account createInvoice(String invoiceName, String industry) {
        Account acc = new Account();
        acc.Name        = invoiceName;
        acc.Industry    = industry;
        acc.Type        = 'Prospect';
        acc.Description = 'Created via InvoiceManager';
        insert acc;
        return acc;
    }

    /**
     * Fetches Accounts filtered by Type (simulates fetching invoices by status).
     * @param type - Account Type value to filter by (e.g., Prospect, Customer)
     * @return List of matching Account records
     */
    public static List<Account> getInvoicesByType(String type) {
        return [
            SELECT Id, Name, Industry, Type, Description, CreatedDate
            FROM Account
            WHERE Type = :type
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }

    /**
     * Updates the Type field on an Account (simulates marking invoice status).
     * @param accountId - Id of the Account to update
     * @param newType   - New Type value (e.g., Customer - Direct, Partner)
     */
    public static void updateInvoiceStatus(Id accountId, String newType) {
        Account acc = [
            SELECT Id, Type
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        acc.Type = newType;
        update acc;
    }

    /**
     * Deletes an Account record by Id (simulates removing an invoice).
     * @param accountId - Id of the Account to delete
     */
    public static void removeInvoice(Id accountId) {
        Account acc = [
            SELECT Id
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        delete acc;
    }
}