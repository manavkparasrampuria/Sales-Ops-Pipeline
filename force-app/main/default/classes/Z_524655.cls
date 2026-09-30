/**
 * @description A simple public utility class with a single static method
 *              that accepts a String input and returns a greeting string.
 *              No SOQL, no DML, and no external dependencies.
 * @author      Copado AI
 * @userStory   US-0001366
 */
public class Z_524655 {

    /**
     * @description Returns a greeting string for the provided name.
     * @param  name  The name to greet. If blank, defaults to 'World'.
     * @return       A greeting string in the format "Hello, <name>!".
     */
    public static String greet(String name) {
        String safeName = String.isBlank(name) ? 'World' : name.trim();
        return 'Hello, ' + safeName + '!';
    }
}