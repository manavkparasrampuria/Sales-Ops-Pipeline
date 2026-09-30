public class Z_Utility313993 {
    /**
     * Returns a greeting string for the given input name.
     * @param name The name to greet.
     * @return A greeting string.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }

    /**
     * Returns a farewell string for the given input name.
     * @param name The name to bid farewell to.
     * @return A farewell string.
     */
    public static String farewell(String name) {
        if (String.isBlank(name)) {
            return 'Goodbye, World!';
        }
        return 'Goodbye, ' + name + '!';
    }
}