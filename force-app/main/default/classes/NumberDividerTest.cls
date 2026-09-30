@Is{!Environment.IvanTest}
private class NumberDivider{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup{!Environment.IvanTest}Data() {
        // No DML needed for pure logic tests
    }

    // Positive: standard division
    @Is{!Environment.IvanTest}
    static void testDivide_PositiveNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.divide(10, 2);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(5, result, 'Expected 10 / 2 = 5');
    }

    // Positive: decimal result
    @Is{!Environment.IvanTest}
    static void testDivide_DecimalResult() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.divide(7, 2);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(3.5, result, 'Expected 7 / 2 = 3.5');
    }

    // Positive: negative numbers
    @Is{!Environment.IvanTest}
    static void testDivide_NegativeNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.divide(-10, 2);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(-5, result, 'Expected -10 / 2 = -5');
    }

    // Positive: both negative
    @Is{!Environment.IvanTest}
    static void testDivide_BothNegative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.divide(-10, -2);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(5, result, 'Expected -10 / -2 = 5');
    }

    // Positive: zero dividend
    @Is{!Environment.IvanTest}
    static void testDivide_ZeroDividend() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.divide(0, 5);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(0, result, 'Expected 0 / 5 = 0');
    }

    // Negative: division by zero throws exception
    @Is{!Environment.IvanTest}
    static void testDivide_ByZero_ThrowsException() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            NumberDivider.divide(10, 0);
            System.assert(false, 'Expected IllegalArgumentException was not thrown');
        } catch (IllegalArgumentException ex) {
            System.assertEquals('Division by zero is not allowed.', ex.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    // Positive: safeDivide returns null on zero divisor
    @Is{!Environment.IvanTest}
    static void testSafeDivide_ByZero_ReturnsNull() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.safeDivide(10, 0);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(null, result, 'Expected null when dividing by zero with safeDivide');
    }

    // Positive: safeDivide normal case
    @Is{!Environment.IvanTest}
    static void testSafeDivide_NormalCase() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = NumberDivider.safeDivide(20, 4);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(5, result, 'Expected 20 / 4 = 5');
    }

    // Bulk: multiple divisions in a loop
    @Is{!Environment.IvanTest}
    static void testDivide_BulkOperations() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        for (Integer i = 1; i <= 200; i++) {
            Decimal result = NumberDivider.divide(Decimal.valueOf(i * 10), Decimal.valueOf(i));
            System.assertEquals(10, result, 'Expected result to be 10 for all iterations');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}