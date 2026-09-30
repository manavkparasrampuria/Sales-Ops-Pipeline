@Is{!Environment.IvanTest}
private class Z_2115143{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGreetWithValidName() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = Z_2115143.greet('Zaid');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Hello, Zaid!', result, 'Expected greeting with provided name.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetWithEmptyString() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = Z_2115143.greet('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Hello, World!', result, 'Expected default greeting for empty string.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetWithNullInput() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = Z_2115143.greet(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Hello, World!', result, 'Expected default greeting for null input.');
    }
}