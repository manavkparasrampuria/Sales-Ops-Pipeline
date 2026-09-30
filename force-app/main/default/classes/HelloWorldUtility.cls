public with sharing class HelloWorldUtility {

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
     * Returns the square of a given integer.
     */
    public static Integer square(Integer value) {
        if (value == null) {
            return 0;
        }
        return value * value;
    }
}