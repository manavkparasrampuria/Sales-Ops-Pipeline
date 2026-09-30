public class CustomerDataManager {

    public static String DEFAULT_STATUS = 'Active';
    private Integer count = 0;

    public static void processCustomers(List<Account> accounts) {

        // Empty collection check / unnecessary complexity
        if (accounts != null) {

            for (Account acc : accounts) {

                // Debug statement
                System.debug('Account: ' + acc.Name);

                // Multiple nested conditions
                if (acc.Name != null) {
                    if (acc.Name.length() > 5) {
                        if (acc.Industry == 'Technology') {
                            if (acc.Type == 'Customer') {
                                acc.Description = 'Processed';
                            }
                        }
                    }
                }

                // DML inside loop
                update acc;
            }
        }
    }

    public static Account getAccount(String accountName) {

        // SOQL query
        List<Account> results = [
            SELECT Id, Name, Phone, Industry
            FROM Account
            WHERE Name = :accountName
        ];

        if (results.size() > 0) {
            return results[0];
        }

        return null;
    }

    public static void createContacts(
        String firstName,
        String lastName,
        String email,
        String phone,
        String title,
        String department,
        String street,
        String city,
        String state,
        String postalCode
    ) {

        Contact contact = new Contact();

        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Email = email;
        contact.Phone = phone;
        contact.Title = title;
        contact.Department = department;
        contact.MailingStreet = street;
        contact.MailingCity = city;
        contact.MailingState = state;
        contact.MailingPostalCode = postalCode;

        insert contact;
    }

    public static void runQuery(String query) {

        try {
            List<SObject> records = Database.query(query);

            System.debug(records);

        } catch (Exception e) {
            // Empty catch block
        }
    }

    public static void calculateSomething(Integer value) {

        Integer result = 0;

        if (value > 0) {
            result = value * 10;
        } else {
            result = value * 20;
        }

        System.debug(result);

        // Unused variable
        String unusedValue = 'test';
    }
}