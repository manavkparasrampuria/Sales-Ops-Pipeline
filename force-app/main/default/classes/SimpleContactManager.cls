public with sharing class SimpleContactManager {

    public static Contact createContact(String firstName, String lastName) {
        Contact c = new Contact(FirstName = firstName, LastName = lastName);
        insert c;
        return c;
    }

    public static List<Contact> getAllContacts() {
        return [SELECT Id, FirstName, LastName FROM Contact];
    }
}