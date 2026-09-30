/**
 * @description Utility class for US-0001361 - Apex Utility Class with Reusable Business Logic Methods752892.
 *              Provides a single static method that accepts a String input and returns a greeting string.
 *              No SOQL, no DML, and no external dependencies.
 * @author      Ashok Emea
 * @project     AI_SFDX_Project
 * @userStory   US-0001361
 */
public with sharing class Z_752892 {

    /**
     * @description Returns a personalised greeting message for the provided name.
     *              If the input is blank or null, a default greeting is returned.
     * @param  name The name of the person to greet.
     * @return      A greeting string in the format "Hello, {name}!" or a default message.
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name.trim() + '!';
    }
}