public with sharing class NumberDivider {

    /**
     * Divides two numbers and returns the result.
     * @param dividend The number to be divided.
     * @param divisor  The number to divide by.
     * @return         The result of the division.
     * @throws         IllegalArgumentException if the divisor is zero.
     */
    public static Decimal divide(Decimal dividend, Decimal divisor) {
        if (divisor == 0) {
            throw new IllegalArgumentException('Division by zero is not allowed.');
        }
        return dividend / divisor;
    }

    /**
     * Safe divide that returns null instead of throwing on division by zero.
     * @param dividend The number to be divided.
     * @param divisor  The number to divide by.
     * @return         The result of the division, or null if divisor is zero.
     */
    public static Decimal safeDivide(Decimal dividend, Decimal divisor) {
        if (divisor == 0) {
            return null;
        }
        return dividend / divisor;
    }
}