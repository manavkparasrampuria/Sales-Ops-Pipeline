public class Z_487815 {
    /**
     * Returns a greeting string for the given name input.
     * @param name - The name to greet
     * @return A greeting string
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
}