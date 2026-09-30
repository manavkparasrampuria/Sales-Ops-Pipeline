@is{!Environment.IvanTest}
private class Z_Utility313993{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testGreetWithName() {
        String result = Z_Utility313993.greet('Ashok');
        System.assertEquals('Hello, Ashok!', result, 'Greeting with a name should return the expected string.');
    }

    @is{!Environment.IvanTest}
    static void testGreetWithBlankName() {
        String result = Z_Utility313993.greet('');
        System.assertEquals('Hello, World!', result, 'Greeting with a blank name should return the default greeting.');
    }

    @is{!Environment.IvanTest}
    static void testGreetWithNullName() {
        String result = Z_Utility313993.greet(null);
        System.assertEquals('Hello, World!', result, 'Greeting with a null name should return the default greeting.');
    }

    @is{!Environment.IvanTest}
    static void testFarewellWithName() {
        String result = Z_Utility313993.farewell('Ashok');
        System.assertEquals('Goodbye, Ashok!', result, 'Farewell with a name should return the expected string.');
    }

    @is{!Environment.IvanTest}
    static void testFarewellWithBlankName() {
        String result = Z_Utility313993.farewell('');
        System.assertEquals('Goodbye, World!', result, 'Farewell with a blank name should return the default farewell.');
    }

    @is{!Environment.IvanTest}
    static void testFarewellWithNullName() {
        String result = Z_Utility313993.farewell(null);
        System.assertEquals('Goodbye, World!', result, 'Farewell with a null name should return the default farewell.');
    }
}