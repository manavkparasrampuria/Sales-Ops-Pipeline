public with sharing class SimpleUtility {

    /**
     * Returns a greeting message for the given name.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }

    /**
     * Returns the sum of two integers.
     */
    public static Integer add(Integer a, Integer b) {
        return a + b;
    }

    /**
     * Checks if a given string is a palindrome.
     */
    public static Boolean isPalindrome(String value) {
        if (String.isBlank(value)) {
            return false;
        }
        String cleaned = value.toLowerCase().trim();
        return cleaned == cleaned.reverse();
    }
}