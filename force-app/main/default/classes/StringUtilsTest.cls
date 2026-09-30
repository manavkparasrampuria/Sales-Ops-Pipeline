@is{!Environment.IvanTest}
private class StringUtils{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testIsBlank() {
        System.assertEquals(true, StringUtils.isBlank(null));
        System.assertEquals(true, StringUtils.isBlank(''));
        System.assertEquals(true, StringUtils.isBlank('   '));
        System.assertEquals(false, StringUtils.isBlank('abc'));
    }

    @is{!Environment.IvanTest}
    static void testCapitalize() {
        System.assertEquals('Hello', StringUtils.capitalize('hello'));
        System.assertEquals('World', StringUtils.capitalize('WORLD'));
        System.assertEquals(null, StringUtils.capitalize(null));
        System.assertEquals('', StringUtils.capitalize(''));
    }

    @is{!Environment.IvanTest}
    static void testTruncate() {
        System.assertEquals('Hello', StringUtils.truncate('Hello World', 5));
        System.assertEquals('Hi', StringUtils.truncate('Hi', 5));
        System.assertEquals(null, StringUtils.truncate(null, 5));
        System.assertEquals('abc', StringUtils.truncate('abc', null));
    }

    @is{!Environment.IvanTest}
    static void testSplitAndTrim() {
        List<String> result = StringUtils.splitAndTrim('a, b ,, c', ',');
        System.assertEquals(3, result.size());
        System.assertEquals('a', result[0]);
        System.assertEquals('b', result[1]);
        System.assertEquals('c', result[2]);

        List<String> emptyResult = StringUtils.splitAndTrim(null, ',');
        System.assertEquals(0, emptyResult.size());
    }

    @is{!Environment.IvanTest}
    static void testJoinNonBlank() {
        List<String> values = new List<String>{'a', '', ' ', 'b', null, 'c'};
        String joined = StringUtils.joinNonBlank(values, '-');
        System.assertEquals('a-b-c', joined);
        System.assertEquals('', StringUtils.joinNonBlank(null, '-'));
    }
}