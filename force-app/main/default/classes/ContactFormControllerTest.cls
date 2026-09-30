@Is{!Environment.IvanTest}
public with sharing class ContactFormController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Contact con = new Contact(
            FirstName = '{!Environment.IvanTest}',
            LastName = 'User',
            Email = 'testuser@example.com',
            Phone = '1234567890'
        );
        insert con;
    }

    @Is{!Environment.IvanTest}
    static void testCreateContact_Positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Id contactId = ContactFormController.createContact('John', 'Doe', 'john.doe@example.com', '9876543210');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Contact result = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId];
        System.assertEquals('John', result.FirstName, 'First name should match');
        System.assertEquals('Doe', result.LastName, 'Last name should match');
        System.assertEquals('john.doe@example.com', result.Email, 'Email should match');
        System.assertEquals('9876543210', result.Phone, 'Phone should match');
    }

    @Is{!Environment.IvanTest}
    static void testCreateContact_LastNameOnly() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Id contactId = ContactFormController.createContact(null, 'Smith', null, null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Contact result = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];
        System.assertEquals('Smith', result.LastName, 'Last name should match');
    }

    @Is{!Environment.IvanTest}
    static void testCreateContact_Negative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            ContactFormController.createContact(null, null, null, null);
            System.assert(false, 'Expected exception was not thrown');
        } catch (AuraHandledException e) {
            System.assertNotEquals(null, e.getMessage(), 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testCreateContact_Bulk() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        for (Integer i = 0; i < 50; i++) {
            ContactFormController.createContact('Bulk' + i, 'User' + i, 'bulk' + i + '@example.com', '000000000' + i);
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Integer count = [SELECT COUNT() FROM Contact WHERE LastName LIKE 'User%'];
        System.assert(count >= 50, 'At least 50 contacts should have been created');
    }
}