@is{!Environment.IvanTest}
private class ContactUtilityService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(
                FirstName  = '{!Environment.IvanTest}',
                LastName   = 'Contact' + i,
                Department = (Math.mod(i, 2) == 0 ? 'Sales' : null),
                Email      = (Math.mod(i, 2) == 0 ? 'test' + i + '@example.com' : null)
            ));
        }
        insert contacts;
    }

    // ─── applyDefaultDepartment: Positive ────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testApplyDefaultDepartment_Positive() {
        List<Contact> noDept = [SELECT Id, Department FROM Contact WHERE Department = null];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ContactUtilityService.applyDefaultDepartment(noDept, 'General');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Contact> updated = [SELECT Id, Department FROM Contact WHERE Id IN :noDept];
        for (Contact con : updated) {
            System.assertEquals('General', con.Department, 'Department should be set to General.');
        }
    }

    @is{!Environment.IvanTest}
    static void testApplyDefaultDepartment_ExistingDeptPreserved() {
        List<Contact> withDept = [SELECT Id, Department FROM Contact WHERE Department = 'Sales'];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ContactUtilityService.applyDefaultDepartment(withDept, 'General');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Contact> updated = [SELECT Id, Department FROM Contact WHERE Id IN :withDept];
        for (Contact con : updated) {
            System.assertEquals('Sales', con.Department, 'Existing Department should not be overwritten.');
        }
    }

    // ─── applyDefaultDepartment: Negative ────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testApplyDefaultDepartment_NullList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ContactUtilityService.applyDefaultDepartment(null, 'General');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'No exception should be thrown for null list.');
    }

    @is{!Environment.IvanTest}
    static void testApplyDefaultDepartment_EmptyList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ContactUtilityService.applyDefaultDepartment(new List<Contact>(), 'General');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'No exception should be thrown for empty list.');
    }

    // ─── getContactsWithNoEmail: Positive ────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testGetContactsWithNoEmail_Positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = ContactUtilityService.getContactsWithNoEmail();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(5, result.size(), 'Expected 5 contacts with no email.');
        for (Contact con : result) {
            System.assertEquals(null, con.Email, 'Email should be null.');
        }
    }

    // ─── uppercaseLastNames: Positive ────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testUppercaseLastNames_Positive() {
        List<Contact> contacts = [SELECT Id, LastName FROM Contact LIMIT 5];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = ContactUtilityService.uppercaseLastNames(contacts);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        for (Contact con : result) {
            System.assertEquals(con.LastName.toUpperCase(), con.LastName, 'LastName should be uppercased.');
        }
    }

    @is{!Environment.IvanTest}
    static void testUppercaseLastNames_NullLastName() {
        Contact con = new Contact(FirstName = 'No', LastName = null);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = ContactUtilityService.uppercaseLastNames(new List<Contact>{ con });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(null, result[0].LastName, 'Null LastName should remain null.');
    }

    // ─── uppercaseLastNames: Negative ────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testUppercaseLastNames_NullList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = ContactUtilityService.uppercaseLastNames(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Result should not be null.');
        System.assertEquals(0, result.size(), 'Result should be empty for null input.');
    }

    @is{!Environment.IvanTest}
    static void testUppercaseLastNames_EmptyList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = ContactUtilityService.uppercaseLastNames(new List<Contact>());
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(0, result.size(), 'Result should be empty for empty input.');
    }

    // ─── Bulk {!Environment.IvanTest}s ───────────────────────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testApplyDefaultDepartment_Bulk() {
        List<Contact> bulkContacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            bulkContacts.add(new Contact(FirstName = 'Bulk', LastName = 'Contact' + i));
        }
        insert bulkContacts;
        List<Contact> fetched = [SELECT Id, Department FROM Contact WHERE LastName LIKE 'Contact%' AND Department = null];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ContactUtilityService.applyDefaultDepartment(fetched, 'Bulk Dept');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<Contact> updated = [SELECT Id, Department FROM Contact WHERE Id IN :fetched];
        for (Contact con : updated) {
            System.assertEquals('Bulk Dept', con.Department, 'Bulk Department should be set.');
        }
    }

    @is{!Environment.IvanTest}
    static void testUppercaseLastNames_Bulk() {
        List<Contact> bulkContacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            bulkContacts.add(new Contact(FirstName = 'Bulk', LastName = 'lastname' + i));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> result = ContactUtilityService.uppercaseLastNames(bulkContacts);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(200, result.size(), 'All 200 contacts should be processed.');
        for (Contact con : result) {
            System.assert(con.LastName == con.LastName.toUpperCase(), 'LastName should be uppercased.');
        }
    }
}