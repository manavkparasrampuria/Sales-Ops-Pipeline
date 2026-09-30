public with sharing class Z_2115143 {

    /**
     * @description Returns a greeting string for the given name.
     * @param name The name to greet.
     * @return A greeting string in the format "Hello, {name}!".
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
}