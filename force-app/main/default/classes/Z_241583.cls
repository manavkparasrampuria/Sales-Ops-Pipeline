public with sharing class Z_241583 {

    /**
     * Returns a greeting string for the given name.
     * @param name The input string to greet.
     * @return A greeting message.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
}