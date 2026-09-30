/**
 * Utility class to calculate the average of three numbers.
 */
public with sharing class AverageCalculator {

    /**
     * Calculates the average of three Decimal numbers.
     * @param num1 First number
     * @param num2 Second number
     * @param num3 Third number
     * @return Decimal average of the three numbers
     */
    public static Decimal average(Decimal num1, Decimal num2, Decimal num3) {
        return (num1 + num2 + num3) / 3;
    }
}