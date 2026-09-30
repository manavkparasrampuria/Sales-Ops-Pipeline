/**
 * @description Unit tests for Z_2135111.
 *              Covers all branches of the greet() method to meet the 75% coverage requirement.
 * @userStory   US-0001408 - Apex Utility Class with Reusable Business Logic Methods2135111
 */
@Is{!Environment.IvanTest}
private class Z_2135111{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGreet_withValidName() {
        String result = Z_2135111.greet('Ashok');
        System.assertEquals('Hello, Ashok!', result, 'Expected a personalised greeting.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withNullInput() {
        String result = Z_2135111.greet(null);
        System.assertEquals('Hello, World!', result, 'Expected default greeting for null input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withBlankInput() {
        String result = Z_2135111.greet('   ');
        System.assertEquals('Hello, World!', result, 'Expected default greeting for blank input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withNameContainingWhitespace() {
        String result = Z_2135111.greet('  Copado  ');
        System.assertEquals('Hello, Copado!', result, 'Expected trimmed name in greeting.');
    }
}