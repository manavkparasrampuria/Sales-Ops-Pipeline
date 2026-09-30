@Is{!Environment.IvanTest}
private class SimpleGreeting{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        // No data setup needed for this utility class
    }

    @Is{!Environment.IvanTest}
    static void testGreetInstance() {
        SimpleGreeting greeting = new SimpleGreeting('Ashok');
        String result = greeting.greet();
        System.assertEquals('Hello, Ashok! Welcome to Salesforce.', result, 'Instance greet message should match.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetStatic() {
        String result = SimpleGreeting.greetStatic('World');
        System.assertEquals('Hello, World! Welcome to Salesforce.', result, 'Static greet message should match.');
    }

    @Is{!Environment.IvanTest}
    static void testGreetEmpty() {
        String result = SimpleGreeting.greetStatic('');
        System.assertEquals('Hello, ! Welcome to Salesforce.', result, 'Empty name should still return a valid greeting.');
    }
}