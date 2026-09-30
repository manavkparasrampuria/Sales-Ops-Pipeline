/**
 * @description Utility class providing reusable business logic methods.
 *              Part of User Story US-0001445 - Apex Utility Class with
 *              Reusable Business Logic Methods985480.
 *
 * @author      Ashok Emea
 * @project     AI_SFDX_Project
 * @since       2026-09-21
 */
public with sharing class Z_985480 {

    /**
     * @description Accepts a String input and returns a personalised greeting.
     *              Returns a default greeting when the input is blank or null.
     *
     * @param  name  The name of the person to greet.
     * @return       A greeting string in the format "Hello, {name}!".
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name.trim() + '!';
    }
}