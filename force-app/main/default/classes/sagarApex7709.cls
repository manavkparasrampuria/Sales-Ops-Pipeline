/**
 * @class       sagarApex7709
 * @description Utility class providing common helper operations.
 *              Created as part of CPD_US_7709 in the AI_SFDX_Project.
 * @author      Copado Build Agent
 * @date        2026-09-08
 */
public with sharing class sagarApex7709 {

    // ─── Inner Wrapper ────────────────────────────────────────────────────────

    /**
     * @description Simple result wrapper returned by utility methods.
     */
    public class Result {
        public Boolean success { get; private set; }
        public String  message { get; private set; }
        public Object  data    { get; private set; }

        public Result(Boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data    = data;
        }
    }

    // ─── Arithmetic Helpers ───────────────────────────────────────────────────

    /**
     * @description Adds two integers and returns the sum.
     * @param  a First operand.
     * @param  b Second operand.
     * @return   Sum of a and b.
     */
    public static Integer add(Integer a, Integer b) {
        return a + b;
    }

    /**
     * @description Subtracts b from a and returns the difference.
     * @param  a Minuend.
     * @param  b Subtrahend.
     * @return   Difference of a and b.
     */
    public static Integer subtract(Integer a, Integer b) {
        return a - b;
    }

    /**
     * @description Multiplies two integers and returns the product.
     * @param  a First factor.
     * @param  b Second factor.
     * @return   Product of a and b.
     */
    public static Integer multiply(Integer a, Integer b) {
        return a * b;
    }

    // ─── String Helpers ───────────────────────────────────────────────────────

    /**
     * @description Checks whether a given string is blank or null.
     * @param  value The string to evaluate.
     * @return       True if blank or null, false otherwise.
     */
    public static Boolean isBlank(String value) {
        return String.isBlank(value);
    }

    /**
     * @description Capitalises the first letter of each word in a string.
     * @param  value The input string.
     * @return       Title-cased string, or empty string if input is blank.
     */
    public static String toTitleCase(String value) {
        if (String.isBlank(value)) {
            return '';
        }
        List<String> words  = value.trim().split(' ');
        List<String> result = new List<String>();
        for (String word : words) {
            if (String.isNotBlank(word)) {
                result.add(word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase());
            }
        }
        return String.join(result, ' ');
    }

    // ─── Result Factory ───────────────────────────────────────────────────────

    /**
     * @description Builds a success Result wrapper.
     * @param  message Descriptive success message.
     * @param  data    Payload to include in the result.
     * @return         Populated Result instance.
     */
    public static Result buildSuccess(String message, Object data) {
        return new Result(true, message, data);
    }

    /**
     * @description Builds a failure Result wrapper.
     * @param  message Descriptive error message.
     * @return         Populated Result instance with null data.
     */
    public static Result buildError(String message) {
        return new Result(false, message, null);
    }
}