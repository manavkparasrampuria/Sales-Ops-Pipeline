/**
 * @description A simple utility class that provides a greeting method.
 *              No SOQL, no DML, and no external dependencies.
 * @author      Zaid Alam
 * @date        2026-09-09
 */
public with sharing class Z_679957 {

    /**
     * @description Accepts a String input and returns a personalised greeting string.
     * @param  name The name of the person to greet.
     * @return      A greeting string in the format "Hello, {name}!".
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
}