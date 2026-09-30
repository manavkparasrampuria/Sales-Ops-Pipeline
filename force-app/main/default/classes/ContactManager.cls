public class ContactManager {
    
    public static void createContact(String firstName, String lastName, String email) {
        Contact c = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email
        );
        insert c;
    }
}