/**
 * DemoBadApexClass
 * PURPOSE: Intentionally bad Apex class for demo purposes.
 * Triggers violations for: PMD, SFDX Scanner (Salesforce Code Analyzer), and Apex {!Environment.IvanTest}s.
 *
 * VIOLATIONS EMBEDDED:
 * [PMD] ApexCRUDViolation         - SOQL without CRUD/FLS check (Priority 1)
 * [PMD] AvoidHardcodingId         - Hard-coded Salesforce Record ID (Priority 2)
 * [PMD] EmptyCatchBlock           - Empty catch block (Priority 3)
 * [PMD] ApexSOQLInjection         - Dynamic SOQL with unescaped input (Priority 1)
 * [PMD] UnusedLocalVariable       - Variable declared but never used (Priority 3)
 * [PMD] AvoidDebugStatements      - System.debug in production code (Priority 3)
 * [SFDX/SGA] ApexCRUDViolation   - Same as above, also caught by Graph Engine
 * [SFDX/PMD-AppExchange] SOQL Injection - Dynamic SOQL injection risk
 * [Apex {!Environment.IvanTest}] Failing assertion   - System.assert(false) guarantees test failure
 * [Apex {!Environment.IvanTest}] Low coverage        - Only ~30% of DemoBadApexClass is covered
 */
public without sharing class DemoBadApexClass {

    // [PMD: AvoidHardcodingId] Hard-coded record ID
    private static final String HARDCODED_ID = '0015g000003ABCDEF';

    /**
     * Runs a SOQL query with no CRUD/FLS check.
     * [PMD: ApexCRUDViolation] [SFDX Scanner: Graph Engine]
     */
    public static List<Account> getAccounts() {
        // [PMD: AvoidDebugStatements]
        System.debug('Fetching accounts - no CRUD check performed');

        // [PMD: UnusedLocalVariable]
        Integer unusedCounter = 0;

        // No Schema.sObjectType.Account.isAccessible() check before query
        return [SELECT Id, Name, Phone FROM Account LIMIT 50];
    }

    /**
     * Dynamic SOQL built from raw user input - injection risk.
     * [PMD: ApexSOQLInjection] [SFDX Scanner: PMD-AppExchange engine]
     */
    public static List<Contact> searchContacts(String searchInput) {
        // String.escapeSingleQuotes() is intentionally NOT used
        String query = 'SELECT Id, FirstName, LastName FROM Contact WHERE LastName = \'' + searchInput + '\'';
        return Database.query(query);
    }

    /**
     * Empty catch block swallows all exceptions silently.
     * [PMD: EmptyCatchBlock]
     */
    public static void updateAccount(Id accountId, String newName) {
        try {
            Account a = new Account(Id = accountId, Name = newName);
            update a;
        } catch (Exception e) {
            // [PMD: EmptyCatchBlock] - exception swallowed with no logging or rethrow
        }
    }

    /**
     * Method that is intentionally NOT covered by the test class.
     * Keeps overall coverage below the threshold.
     */
    public static String uncoveredMethod() {
        return 'This line is never executed by tests';
    }

    /**
     * Another uncovered method to push coverage lower.
     */
    public static Decimal calculateDiscount(Decimal price) {
        return price * 0.9;
    }
}