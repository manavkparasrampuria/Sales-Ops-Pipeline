/**
 * @description Utility Apex class for sagarApex2155858.
 *              Provides general-purpose helper methods following
 *              Salesforce development best practices.
 * @author      Copado Build Agent
 * @date        2026-09-25
 */
public with sharing class sagarApex2155858 {

    /**
     * @description Returns a greeting message specific to this class.
     * @return A formatted greeting string.
     */
    public static String getGreeting() {
        return 'Hello from sagarApex2155858!';
    }

    /**
     * @description Adds two integers safely, treating null as zero.
     * @param  a First integer operand.
     * @param  b Second integer operand.
     * @return   Sum of a and b.
     */
    public static Integer addNumbers(Integer a, Integer b) {
        Integer x = (a == null) ? 0 : a;
        Integer y = (b == null) ? 0 : b;
        return x + y;
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
        String emailRegex = '^[a-zA-Z0-9._|\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9-]+\\.([a-zA-Z]{2,4}\\.){0,1}[a-zA-Z]{2,4}$';
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