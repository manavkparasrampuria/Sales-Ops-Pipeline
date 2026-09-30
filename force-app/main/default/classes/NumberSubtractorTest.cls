@is{!Environment.IvanTest}
private class NumberSubtractor{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testSubtract_positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberSubtractor.subtract(10, 4);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(6, result, 'Expected 10 - 4 to equal 6');
    }

    @is{!Environment.IvanTest}
    static void testSubtract_negativeResult() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberSubtractor.subtract(4, 10);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(-6, result, 'Expected 4 - 10 to equal -6');
    }
}