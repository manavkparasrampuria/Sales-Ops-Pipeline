/**
 * @class       Z_2145931
 * @description A reusable utility class providing a simple greeting method.
 *              No SOQL, no DML, and no external dependencies.
 * @author      Ashok Emea
 * @userStory   US-0001451 - Apex Utility Class with Reusable Business Logic Methods2145931
 */
public class Z_2145931 {

    /**
     * @description Returns a personalised greeting string for the given name.
     *              Handles null or blank input gracefully by substituting a default value.
     * @param  name The name of the person to greet.
     * @return      A greeting string in the format "Hello, {name}!".
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            name = 'World';
        }
        return 'Hello, ' + name + '!';
    }
}