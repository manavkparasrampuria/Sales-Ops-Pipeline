/**
 * @description Sample Apex class created for user story CPD_ADD_ORG_2145988.
 * Provides a simple utility method as a placeholder implementation.
 */
public with sharing class sagarApex2145988 {

    /**
     * @description Returns a simple greeting message.
     * @return String greeting message
     */
    public static String getGreeting() {
        return 'Hello from sagarApex2145988!';
    }

    /**
     * @description Adds two integers together.
     * @param a first integer
     * @param b second integer
     * @return Integer sum of a and b
     */
    public static Integer addNumbers(Integer a, Integer b) {
        if (a == null) {
            a = 0;
        }
        if (b == null) {
            b = 0;
        }
        return a + b;
    }
}