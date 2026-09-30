/**
 * @class       Z_2145931{!Environment.IvanTest}
 * @description Unit tests for Z_2145931.
 *              Covers positive, negative, and boundary scenarios.
 * @userStory   US-0001451
 */
@Is{!Environment.IvanTest}
private class Z_2145931{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGreet_withValidName() {
        String result = Z_2145931.greet('Ashok');
        System.assertEquals('Hello, Ashok!', result, 'Expected a personalised greeting.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withNullInput() {
        String result = Z_2145931.greet(null);
        System.assertEquals('Hello, World!', result, 'Expected default greeting for null input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withBlankInput() {
        String result = Z_2145931.greet('   ');
        System.assertEquals('Hello, World!', result, 'Expected default greeting for blank input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withEmptyString() {
        String result = Z_2145931.greet('');
        System.assertEquals('Hello, World!', result, 'Expected default greeting for empty string.');
    }
}