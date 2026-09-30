/**
 * @class       Z_2137357
 * @description A simple utility class that provides a static greeting method.
 *              No SOQL, no DML, and no external dependencies.
 * @author      Copado Orchestrate Agent
 * @date        2026-09-18
 * @userStory   US-0001412
 */
public class Z_2137357 {

    /**
     * @method      greet
     * @description Accepts a String input and returns a personalised greeting string.
     * @param       name  The name of the person to greet. If blank, defaults to 'World'.
     * @return      String  A greeting message in the format "Hello, {name}!"
     */
    public static String greet(String name) {
        String safeName = String.isBlank(name) ? 'World' : name.trim();
        return 'Hello, ' + safeName + '!';
    }
}