public with sharing class ContactEmailService {
    /**
     * Checks whether the given Contact has a populated Email address.
     * @param con the Contact record to check
     * @return true if Email is not null/blank, false otherwise
     */
    public static Boolean hasEmail(Contact con) {
        if (con == null) {
            return false;
        }
        return String.isNotBlank(con.Email);
    }
}