public with sharing class Z_2111076 {

    /**
     * @description Returns a greeting string for the given name.
     * @param name The input string representing the person's name.
     * @return A greeting message as a String.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
}