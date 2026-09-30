@Is{!Environment.IvanTest}
private class SimpleEPAEx{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGetMessage() {
        SimpleEPAEx obj = new SimpleEPAEx();
        System.assertEquals('Hello from SimpleEPAEx!', obj.getMessage(),
            'getMessage() should return the default message.');
    }

    @Is{!Environment.IvanTest}
    static void testStaticGreeting() {
        System.assertEquals('Hello from Static Method!', SimpleEPAEx.staticGreeting(),
            'staticGreeting() should return the static greeting.');
    }

    @Is{!Environment.IvanTest}
    static void testGetFormattedMessageWithValidPrefix() {
        SimpleEPAEx obj = new SimpleEPAEx();
        String result = obj.getFormattedMessage('INFO');
        System.assertEquals('INFO: Hello from SimpleEPAEx!', result,
            'getFormattedMessage() should prepend the prefix correctly.');
    }

    @Is{!Environment.IvanTest}
    static void testGetFormattedMessageWithBlankPrefix() {
        SimpleEPAEx obj = new SimpleEPAEx();
        String result = obj.getFormattedMessage('   ');
        System.assertEquals('Hello from SimpleEPAEx!', result,
            'getFormattedMessage() should return message as-is for blank prefix.');
    }

    @Is{!Environment.IvanTest}
    static void testGetFormattedMessageWithNullPrefix() {
        SimpleEPAEx obj = new SimpleEPAEx();
        String result = obj.getFormattedMessage(null);
        System.assertEquals('Hello from SimpleEPAEx!', result,
            'getFormattedMessage() should return message as-is for null prefix.');
    }

    @Is{!Environment.IvanTest}
    static void testGetFormattedMessageWithLeadingTrailingSpaces() {
        SimpleEPAEx obj = new SimpleEPAEx();
        String result = obj.getFormattedMessage('  WARN  ');
        System.assertEquals('WARN: Hello from SimpleEPAEx!', result,
            'getFormattedMessage() should trim the prefix before formatting.');
    }
}