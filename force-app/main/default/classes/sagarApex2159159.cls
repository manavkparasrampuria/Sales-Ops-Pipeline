/**
 * @description  General-purpose utility Apex class.
 * @author       Copado Build Agent
 * @date         2026-09-28
 */
public with sharing class sagarApex2159159 {

    /**
     * @description Returns a greeting message for the given name.
     * @param  name  The name to greet.
     * @return       A greeting string.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Name must not be blank.');
        }
        return 'Hello, ' + name + '!';
    }

    /**
     * @description Checks whether a given string is blank.
     * @param  value  The string to evaluate.
     * @return        True if blank, false otherwise.
     */
    public static Boolean isBlank(String value) {
        return String.isBlank(value);
    }
}