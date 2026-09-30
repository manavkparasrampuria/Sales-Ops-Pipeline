@Is{!Environment.IvanTest}
private class SimpleContactManager{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Contact c = new Contact(FirstName = 'Setup', LastName = 'Contact');
        insert c;
    }

    @Is{!Environment.IvanTest}
    static void testCreateContact() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Contact c = SimpleContactManager.createContact('John', 'Doe');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, c.Id, 'Contact should have been inserted');
        System.assertEquals('John', c.FirstName, 'First name should match');
        System.assertEquals('Doe', c.LastName, 'Last name should match');
    }

    @Is{!Environment.IvanTest}
    static void testGetAllContacts() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> contacts = SimpleContactManager.getAllContacts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(0, contacts.size(), 'Should return at least one contact');
    }

    @Is{!Environment.IvanTest}
    static void testCreateContactBulk() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(FirstName = 'Bulk', LastName = 'Contact ' + i));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert contacts;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Contact> result = SimpleContactManager.getAllContacts();
        System.assert(result.size() >= 200, 'Should have at least 200 contacts');
    }

    @Is{!Environment.IvanTest}
    static void testTriggerOnContact() {
        // Covers SimpleContactTrigger - before insert
        Contact c = new Contact(FirstName = 'Trigger', LastName = '{!Environment.IvanTest}');
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert c;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Contact inserted = [SELECT Id, Description FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Managed by SimpleContactManager', inserted.Description,
            'Trigger should have set the Description field');
    }
}