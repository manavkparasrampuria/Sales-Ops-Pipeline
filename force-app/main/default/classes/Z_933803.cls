public with sharing class Z_933803 {

    /**
     * @description Returns a greeting string for the provided name.
     * @param name The input string representing the person's name.
     * @return A greeting string in the format "Hello, {name}!".
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
}