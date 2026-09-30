/**
 * @description {!Environment.IvanTest} class for Z_679957.
 *              Covers positive cases and edge cases (blank/null input).
 * @author      Zaid Alam
 * @date        2026-09-09
 */
@Is{!Environment.IvanTest}
private class Z_679957{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGreet_withValidName() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = Z_679957.greet('Zaid');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Hello, Zaid!', result, 'Expected a personalised greeting.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withBlankName() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = Z_679957.greet('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Hello, World!', result, 'Expected default greeting for blank input.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withNullName() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = Z_679957.greet(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Hello, World!', result, 'Expected default greeting for null input.');
    }
}