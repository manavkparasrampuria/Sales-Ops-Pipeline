/**
 * {!Environment.IvanTest} class for AverageCalculator.
 */
@is{!Environment.IvanTest}
private class AverageCalculator{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testAverage_positiveNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = AverageCalculator.average(3, 6, 9);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(6, result, 'Average of 3, 6, 9 should be 6');
    }

    @is{!Environment.IvanTest}
    static void testAverage_negativeNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = AverageCalculator.average(-3, -6, -9);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(-6, result, 'Average of -3, -6, -9 should be -6');
    }

    @is{!Environment.IvanTest}
    static void testAverage_decimalNumbers() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = AverageCalculator.average(1.5, 2.5, 3.5);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(2.5, result, 'Average of 1.5, 2.5, 3.5 should be 2.5');
    }

    @is{!Environment.IvanTest}
    static void testAverage_zeroValues() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = AverageCalculator.average(0, 0, 0);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(0, result, 'Average of 0, 0, 0 should be 0');
    }
}