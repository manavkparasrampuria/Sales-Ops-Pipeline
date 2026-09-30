@is{!Environment.IvanTest}
private class HelloService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        // No DML needed; UserInfo is available in all test contexts
    }

    @is{!Environment.IvanTest}
    static void testGreetCurrentUser_Positive() {
        String expectedName = UserInfo.getName();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = HelloService.greetCurrentUser();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(
            'Hello ' + expectedName,
            result,
            'greetCurrentUser() should return "Hello " followed by the running user\'s name.'
        );
    }

    @is{!Environment.IvanTest}
    static void testGreetCurrentUser_StartsWithHello() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = HelloService.greetCurrentUser();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(
            result.startsWith('Hello '),
            'Result should always start with "Hello ".'
        );
    }

    @is{!Environment.IvanTest}
    static void testGreetCurrentUser_ContainsUserName() {
        String currentUserName = UserInfo.getName();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = HelloService.greetCurrentUser();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(
            result.contains(currentUserName),
            'Result should contain the current user\'s full name.'
        );
    }

    @is{!Environment.IvanTest}
    static void testGreetCurrentUser_NotBlank() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = HelloService.greetCurrentUser();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Result should never be null.');
        System.assert(result.length() > 6, 'Result should be longer than "Hello " alone.');
    }
}