@is{!Environment.IvanTest}
private class ContactEmailService{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testHasEmail_WithEmail() {
        Contact con = new Contact(LastName = '{!Environment.IvanTest}', Email = 'test@example.com');
        System.assertEquals(true, ContactEmailService.hasEmail(con));
    }

    @is{!Environment.IvanTest}
    static void testHasEmail_WithBlankEmail() {
        Contact con = new Contact(LastName = '{!Environment.IvanTest}', Email = '');
        System.assertEquals(false, ContactEmailService.hasEmail(con));
    }

    @is{!Environment.IvanTest}
    static void testHasEmail_WithNullEmail() {
        Contact con = new Contact(LastName = '{!Environment.IvanTest}');
        System.assertEquals(false, ContactEmailService.hasEmail(con));
    }

    @is{!Environment.IvanTest}
    static void testHasEmail_NullContact() {
        System.assertEquals(false, ContactEmailService.hasEmail(null));
    }
}