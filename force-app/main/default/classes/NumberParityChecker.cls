public with sharing class NumberParityChecker {
    /**
     * Determines whether the given integer is even or odd.
     * @param inputValue the integer to evaluate
     * @return 'Even' if the number is even, 'Odd' if the number is odd
     */
    public static String checkParity(Integer inputValue) {
        if (inputValue == null) {
            throw new IllegalArgumentException('Number cannot be null.');
        }
        return Math.mod(inputValue, 2) == 0 ? 'Even' : 'Odd';
    }
}