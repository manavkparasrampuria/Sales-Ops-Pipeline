public with sharing class ContactStatusTriggerHandler {

    public static void handleBeforeInsert(List<Contact> newContacts) {
        for (Contact con : newContacts) {
            if (String.isBlank(con.Title)) {
                con.Title = 'Team Member';
            }
        }
    }

    public static void handleBeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        for (Contact con : newContacts) {
            Contact oldCon = oldMap.get(con.Id);
            if (con.Department != oldCon.Department) {
                con.Description = 'Department changed on: ' + String.valueOf(Date.today());
            }
        }
    }
}