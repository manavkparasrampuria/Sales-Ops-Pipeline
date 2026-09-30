/**
 * @description {!Environment.IvanTest} class for sagarApex2131975.
 */
@is{!Environment.IvanTest}
private class sagarApex2131975{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testGetGreeting() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = sagarApex2131975.getGreeting();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Hello from sagarApex2131975!', result, 'Greeting message should match expected value.');
    }

    @is{!Environment.IvanTest}
    static void testAddNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Integer result1 = sagarApex2131975.addNumbers(2, 3);
        Integer result2 = sagarApex2131975.addNumbers(null, 5);
        Integer result3 = sagarApex2131975.addNumbers(4, null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(5, result1, 'Sum of 2 and 3 should be 5.');
        System.assertEquals(5, result2, 'Sum of null and 5 should be 5.');
        System.assertEquals(4, result3, 'Sum of 4 and null should be 4.');
    }
}