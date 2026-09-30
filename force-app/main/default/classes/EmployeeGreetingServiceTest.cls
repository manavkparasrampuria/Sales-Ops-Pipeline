@Is{!Environment.IvanTest}
private class EmployeeGreetingService{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGreetWithValidName() {
        String result = EmployeeGreetingService.greet('John');
        System.assertEquals('Hello, John! Welcome to our team.', result,
            'Expected a personalised greeting for John.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetWithNullName() {
        String result = EmployeeGreetingService.greet(null);
        System.assertEquals('Hello! Welcome to our team.', result,
            'Expected default greeting for null input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetWithBlankName() {
        String result = EmployeeGreetingService.greet('   ');
        System.assertEquals('Hello! Welcome to our team.', result,
            'Expected default greeting for blank input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetWithLeadingTrailingSpaces() {
        String result = EmployeeGreetingService.greet('  Jane  ');
        System.assertEquals('Hello, Jane! Welcome to our team.', result,
            'Expected trimmed name in greeting.');
    }
}