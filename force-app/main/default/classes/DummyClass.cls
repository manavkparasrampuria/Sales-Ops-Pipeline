public with sharing class DummyClass {

    /**
     * Returns a simple greeting message.
     * Used as a placeholder/demo class.
     */
    public static String getGreeting() {
        return 'Hello from DummyClass!';
    }

    /**
     * Adds two integers together.
     * @param a first number
     * @param b second number
     * @return sum of a and b
     */
    public static Integer addNumbers(Integer a, Integer b) {
        return a + b;
    }
}