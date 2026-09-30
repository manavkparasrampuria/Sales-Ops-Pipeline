@is{!Environment.IvanTest}
private class NumberParityChecker{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testEvenNumber_positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = NumberParityChecker.checkParity(4);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Even', result, '4 should be identified as Even');
    }

    @is{!Environment.IvanTest}
    static void testOddNumber_positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = NumberParityChecker.checkParity(7);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Odd', result, '7 should be identified as Odd');
    }

    @is{!Environment.IvanTest}
    static void testNegativeEvenNumber_positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = NumberParityChecker.checkParity(-8);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Even', result, '-8 should be identified as Even');
    }

    @is{!Environment.IvanTest}
    static void testZero_edgeCase() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = NumberParityChecker.checkParity(0);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Even', result, '0 should be identified as Even');
    }

    @is{!Environment.IvanTest}
    static void testNullInput_negative() {
        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            NumberParityChecker.checkParity(null);
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(true, exceptionThrown, 'Null input should throw an IllegalArgumentException');
    }
}