@Is{!Environment.IvanTest}
public class Simple{!Environment.IvanTest}Helper {

    public static Contact createContact() {
        return createContact('{!Environment.IvanTest}', 'Contact', 0);
    }

    public static Contact createContact(String firstName, String lastName, Integer uniqueSuffix) {
        return new Contact(
            FirstName = firstName,
            LastName  = lastName,
            Email     = 'test' + uniqueSuffix + '@example.com',
            LeadSource = 'Web'
        );
    }

    public static List<Contact> createContacts(Integer numberOfContacts) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < numberOfContacts; i++) {
            contacts.add(createContact('{!Environment.IvanTest}', 'Contact' + i, i));
        }
        return contacts;
    }

    public static Contact createAndInsertContact() {
        Contact con = createContact();
        insert con;
        return con;
    }
}