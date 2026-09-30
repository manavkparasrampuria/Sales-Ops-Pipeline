public with sharing class ContactFormController {

    @AuraEnabled
    public static Id createContact(String firstName, String lastName, String email, String phone) {
        try {
            Contact con = new Contact();
            con.FirstName = firstName;
            con.LastName = lastName;
            con.Email = email;
            con.Phone = phone;
            insert con;
            return con.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}