/**
 * @description {!Environment.IvanTest} class for sagarApex2155858.
 */
@is{!Environment.IvanTest}
private class sagarApex2155858{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testGetGreeting() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = sagarApex2155858.getGreeting();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Hello from sagarApex2155858!', result, 'Greeting message should match expected value.');
    }

    @is{!Environment.IvanTest}
    static void testAddNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Integer result1 = sagarApex2155858.addNumbers(2, 3);
        Integer result2 = sagarApex2155858.addNumbers(null, 5);
        Integer result3 = sagarApex2155858.addNumbers(4, null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(5, result1, 'Sum of 2 and 3 should be 5.');
        System.assertEquals(5, result2, 'Sum of null and 5 should be 5.');
        System.assertEquals(4, result3, 'Sum of 4 and null should be 4.');
    }

    @is{!Environment.IvanTest}
    static void testIsValidEmail() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean valid   = sagarApex2155858.isValidEmail('test@example.com');
        Boolean invalid = sagarApex2155858.isValidEmail('not-an-email');
        Boolean blank   = sagarApex2155858.isValidEmail('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(true,  valid,   'Valid email should return true.');
        System.assertEquals(false, invalid, 'Invalid email should return false.');
        System.assertEquals(false, blank,   'Blank email should return false.');
    }

    @is{!Environment.IvanTest}
    static void testGetAccountsByKeyword() {
        Account acc = new Account(Name = 'sagarApex2155858 {!Environment.IvanTest} Account');
        insert acc;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> results      = sagarApex2155858.getAccountsByKeyword('sagarApex2155858');
        List<Account> emptyResults = sagarApex2155858.getAccountsByKeyword('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(!results.isEmpty(), 'Should find at least one account.');
        System.assertEquals(0, emptyResults.size(), 'Blank keyword should return empty list.');
    }
}