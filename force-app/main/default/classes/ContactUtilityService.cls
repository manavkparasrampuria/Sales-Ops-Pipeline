public with sharing class ContactUtilityService {

    /**
     * Bulkified method to set a default Department on Contacts that have none.
     * Performs DML internally.
     */
    public static void applyDefaultDepartment(List<Contact> contacts, String defaultDept) {
        if (contacts == null || contacts.isEmpty()) {
            return;
        }
        List<Contact> toUpdate = new List<Contact>();
        for (Contact con : contacts) {
            if (String.isBlank(con.Department)) {
                con.Department = defaultDept;
                toUpdate.add(con);
            }
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    /**
     * Returns all Contacts whose Email is blank.
     */
    public static List<Contact> getContactsWithNoEmail() {
        return [
            SELECT Id, FirstName, LastName, Email, Department
            FROM Contact
            WHERE Email = null
        ];
    }

    /**
     * Bulkified method to uppercase the LastName of each Contact in memory.
     * No DML performed — caller is responsible for saving.
     */
    public static List<Contact> uppercaseLastNames(List<Contact> contacts) {
        if (contacts == null || contacts.isEmpty()) {
            return new List<Contact>();
        }
        for (Contact con : contacts) {
            if (con.LastName != null) {
                con.LastName = con.LastName.toUpperCase();
            }
        }
        return contacts;
    }
}