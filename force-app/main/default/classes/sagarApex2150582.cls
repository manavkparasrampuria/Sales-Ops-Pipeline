/**
 * @description Utility Apex class for sagarApex2150582.
 *              Provides general-purpose helper methods following
 *              Salesforce development best practices.
 * @author      Copado Build Agent
 * @date        2026-09-23
 */
public with sharing class sagarApex2150582 {

    /**
     * @description Returns a greeting message for the given name.
     * @param  name The name to greet.
     * @return      A formatted greeting string.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Name cannot be blank.');
        }
        return 'Hello, ' + name + '! Welcome to sagarApex2150582.';
    }

    /**
     * @description Checks whether a given string is a valid email format.
     * @param  email The email address to validate.
     * @return       True if valid, false otherwise.
     */
    public static Boolean isValidEmail(String email) {
        if (String.isBlank(email)) {
            return false;
        }
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9-]+\\.([a-zA-Z]{2,4}\\.){0,1}[a-zA-Z]{2,4}$';
        Pattern p = Pattern.compile(emailRegex);
        Matcher m = p.matcher(email);
        return m.matches();
    }

    /**
     * @description Safely retrieves a list of Accounts by name keyword.
     * @param  keyword The keyword to search in Account names.
     * @return         List of matching Account records.
     */
    public static List<Account> getAccountsByKeyword(String keyword) {
        if (String.isBlank(keyword)) {
            return new List<Account>();
        }
        String searchTerm = '%' + keyword + '%';
        return [
            SELECT Id, Name, Phone, BillingCity
            FROM Account
            WHERE Name LIKE :searchTerm
            WITH SECURITY_ENFORCED
            LIMIT 200
        ];
    }
}