/**
 * YExecuteLogic
 *
 * Validates all 9 input parameters and logs meaningful debug output.
 * Parameters that are null, empty, or whitespace-only are treated as missing.
 * A final debug statement reports the total count of valid (non-blank) parameters.
 */
public class YExecuteLogic {

    /**
     * Checks each of the 9 String parameters and logs whether it is populated or missing.
     *
     * @param a First parameter
     * @param b Second parameter
     * @param c Third parameter
     * @param d Fourth parameter
     * @param e Fifth parameter
     * @param f Sixth parameter
     * @param g Seventh parameter
     * @param h Eighth parameter
     * @param i Ninth parameter
     */
    public void check(String a, String b, String c, String d, String e,
                      String f, String g, String h, String i) {

        // Map parameter names to their values to keep the logic DRY and readable
        List<String> names  = new List<String>{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i' };
        List<String> values = new List<String>{  a,   b,   c,   d,   e,   f,   g,   h,   i  };

        Integer validCount = 0;

        for (Integer idx = 0; idx < names.size(); idx++) {
            String paramName  = names[idx];
            String paramValue = values[idx];

            if (String.isNotBlank(paramValue)) {
                System.debug('Parameter ' + paramName + ' = ' + paramValue);
                validCount++;
            } else {
                System.debug('Parameter ' + paramName + ' is missing');
            }
        }

        System.debug('Valid parameter count = ' + validCount);
    }
}