/**
 * @description A simple utility class for the CloudSphere project.
 *              Provides common helper methods for string manipulation,
 *              date formatting, and basic math operations.
 * @author      Copado Build Agent
 * @date        2026-09-28
 */
public with sharing class CloudSphereUtility {

    // ─── String Helpers ───────────────────────────────────────────────────────

    /**
     * @description Returns true if the given string is null or blank.
     * @param  value The string to evaluate.
     * @return       Boolean result.
     */
    public static Boolean isBlank(String value) {
        return String.isBlank(value);
    }

    /**
     * @description Capitalizes the first letter of a string.
     * @param  value The input string.
     * @return       The capitalized string, or null if input is blank.
     */
    public static String capitalize(String value) {
        if (String.isBlank(value)) {
            return null;
        }
        return value.substring(0, 1).toUpperCase() + value.substring(1).toLowerCase();
    }

    // ─── Date Helpers ─────────────────────────────────────────────────────────

    /**
     * @description Returns today's date formatted as 'YYYY-MM-DD'.
     * @return       Formatted date string.
     */
    public static String getTodayFormatted() {
        return String.valueOf(Date.today());
    }

    /**
     * @description Calculates the number of days between two dates.
     * @param  startDate The start date.
     * @param  endDate   The end date.
     * @return           Number of days between the two dates.
     */
    public static Integer daysBetween(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            return null;
        }
        return startDate.daysBetween(endDate);
    }

    // ─── Math Helpers ─────────────────────────────────────────────────────────

    /**
     * @description Returns the larger of two integers.
     * @param  a First integer.
     * @param  b Second integer.
     * @return   The maximum value.
     */
    public static Integer max(Integer a, Integer b) {
        return (a >= b) ? a : b;
    }

    /**
     * @description Returns the smaller of two integers.
     * @param  a First integer.
     * @param  b Second integer.
     * @return   The minimum value.
     */
    public static Integer min(Integer a, Integer b) {
        return (a <= b) ? a : b;
    }
}