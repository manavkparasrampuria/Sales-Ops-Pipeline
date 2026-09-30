@is{!Environment.IvanTest}
private class DummyClass{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testGetGreeting() {
        String result = DummyClass.getGreeting();
        System.assertEquals('Hello from DummyClass!', result, 'Greeting message should match expected value');
    }

    @is{!Environment.IvanTest}
    static void testAddNumbers() {
        Integer result = DummyClass.addNumbers(3, 4);
        System.assertEquals(7, result, 'Sum should be 7');
    }

    @is{!Environment.IvanTest}
    static void testAddNumbersNegative() {
        Integer result = DummyClass.addNumbers(-5, 5);
        System.assertEquals(0, result, 'Sum should be 0');
    }
}