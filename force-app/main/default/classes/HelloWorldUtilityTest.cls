@is{!Environment.IvanTest}
private class HelloWorldUtility{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testGreet_withName() {
        String result = HelloWorldUtility.greet('Copado');
        System.assertEquals('Hello, Copado!', result, 'Should return personalized greeting');
    }

    @is{!Environment.IvanTest}
    static void testGreet_withBlankName() {
        String result = HelloWorldUtility.greet('');
        System.assertEquals('Hello, World!', result, 'Should return default greeting for blank input');
    }

    @is{!Environment.IvanTest}
    static void testGreet_withNull() {
        String result = HelloWorldUtility.greet(null);
        System.assertEquals('Hello, World!', result, 'Should return default greeting for null input');
    }

    @is{!Environment.IvanTest}
    static void testSquare_positive() {
        System.assertEquals(25, HelloWorldUtility.square(5), 'Square of 5 should be 25');
    }

    @is{!Environment.IvanTest}
    static void testSquare_zero() {
        System.assertEquals(0, HelloWorldUtility.square(0), 'Square of 0 should be 0');
    }

    @is{!Environment.IvanTest}
    static void testSquare_null() {
        System.assertEquals(0, HelloWorldUtility.square(null), 'Square of null should return 0');
    }
}