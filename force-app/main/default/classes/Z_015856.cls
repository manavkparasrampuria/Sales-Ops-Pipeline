public class Z_015856 {
    public static String greet(String input) {
        if (String.isBlank(input)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + input + '!';
    }
}