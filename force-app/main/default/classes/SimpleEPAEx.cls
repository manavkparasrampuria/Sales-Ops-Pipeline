public with sharing class SimpleEPAEx {

    // Public variable
    public String message { get; set; }

    // Constructor
    public SimpleEPAEx() {
        this.message = 'Hello from SimpleEPAEx!';
    }

    // Method to return the message
    public String getMessage() {
        return message;
    }

    // Static method to return a greeting
    public static String staticGreeting() {
        return 'Hello from Static Method!';
    }

    /**
     * Returns the instance message prefixed with a custom label.
     * If the prefix is blank, the message is returned as-is.
     * @param prefix A custom label to prepend to the message.
     * @return A formatted string combining the prefix and the message.
     */
    public String getFormattedMessage(String prefix) {
        if (String.isBlank(prefix)) {
            return message;
        }
        return prefix.trim() + ': ' + message;
    }
}