@Is{!Environment.IvanTest}
private class SimpleUtility{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        // No data setup needed for utility methods
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withName() {
        String result = SimpleUtility.greet('Ashok');
        Assert.areEqual('Hello, Ashok!', result, 'Greeting should include the provided name.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withBlankName() {
        String result = SimpleUtility.greet('');
        Assert.areEqual('Hello, World!', result, 'Blank name should return default greeting.');
    }

    @Is{!Environment.IvanTest}
    static void testGreet_withNullName() {
        String result = SimpleUtility.greet(null);
        Assert.areEqual('Hello, World!', result, 'Null name should return default greeting.');
    }

    @Is{!Environment.IvanTest}
    static void testAdd_positiveNumbers() {
        Integer result = SimpleUtility.add(3, 7);
        Assert.areEqual(10, result, 'Sum of 3 and 7 should be 10.');
    }

    @Is{!Environment.IvanTest}
    static void testAdd_negativeNumbers() {
        Integer result = SimpleUtility.add(-5, -3);
        Assert.areEqual(-8, result, 'Sum of -5 and -3 should be -8.');
    }

    @Is{!Environment.IvanTest}
    static void testAdd_mixedNumbers() {
        Integer result = SimpleUtility.add(-4, 10);
        Assert.areEqual(6, result, 'Sum of -4 and 10 should be 6.');
    }

    @Is{!Environment.IvanTest}
    static void testIsPalindrome_validPalindrome() {
        Boolean result = SimpleUtility.isPalindrome('racecar');
        Assert.isTrue(result, 'racecar should be a palindrome.');
    }

    @Is{!Environment.IvanTest}
    static void testIsPalindrome_notPalindrome() {
        Boolean result = SimpleUtility.isPalindrome('hello');
        Assert.isFalse(result, 'hello should not be a palindrome.');
    }

    @Is{!Environment.IvanTest}
    static void testIsPalindrome_blankValue() {
        Boolean result = SimpleUtility.isPalindrome('');
        Assert.isFalse(result, 'Blank string should return false.');
    }

    @Is{!Environment.IvanTest}
    static void testIsPalindrome_nullValue() {
        Boolean result = SimpleUtility.isPalindrome(null);
        Assert.isFalse(result, 'Null value should return false.');
    }

    @Is{!Environment.IvanTest}
    static void testIsPalindrome_caseInsensitive() {
        Boolean result = SimpleUtility.isPalindrome('RaceCar');
        Assert.isTrue(result, 'Palindrome check should be case-insensitive.');
    }
}