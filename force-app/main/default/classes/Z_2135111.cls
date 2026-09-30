/**
 * @description A simple utility class that provides a static greeting method.
 *              No SOQL, no DML, and no external dependencies.
 * @author      Ashok Emea
 * @userStory   US-0001408 - Apex Utility Class with Reusable Business Logic Methods2135111
 */
public with sharing class Z_2135111 {

    /**
     * @description Returns a personalised greeting string for the given name.
     *              Handles null or blank input gracefully by returning a default greeting.
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