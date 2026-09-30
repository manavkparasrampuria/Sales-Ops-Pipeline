@is{!Environment.IvanTest}
private class AddTwoNumbersService{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testValidNumbersReturnCorrectSum() {
        AddTwoNumbersService.Request req = new AddTwoNumbersService.Request();
        req.varNumber1 = 5;
        req.varNumber2 = 7;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<AddTwoNumbersService.Response> responses =
            AddTwoNumbersService.addNumbers(new List<AddTwoNumbersService.Request>{ req });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, responses.size(), 'Expected exactly one response.');
        System.assertEquals(12, responses[0].varSum, 'Sum of 5 and 7 should be 12.');
    }

    @is{!Environment.IvanTest}
    static void testMissingFirstNumberThrowsException() {
        AddTwoNumbersService.Request req = new AddTwoNumbersService.Request();
        req.varNumber1 = null;
        req.varNumber2 = 4;

        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AddTwoNumbersService.addNumbers(new List<AddTwoNumbersService.Request>{ req });
        } catch (AddTwoNumbersService.AddTwoNumbersException ex) {
            exceptionThrown = true;
            System.assertEquals('Both numbers are required to calculate a sum.', ex.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected an exception when the first number is missing.');
    }

    @is{!Environment.IvanTest}
    static void testMissingSecondNumberThrowsException() {
        AddTwoNumbersService.Request req = new AddTwoNumbersService.Request();
        req.varNumber1 = 4;
        req.varNumber2 = null;

        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AddTwoNumbersService.addNumbers(new List<AddTwoNumbersService.Request>{ req });
        } catch (AddTwoNumbersService.AddTwoNumbersException ex) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected an exception when the second number is missing.');
    }

    @is{!Environment.IvanTest}
    static void testNegativeAndDecimalNumbers() {
        AddTwoNumbersService.Request req = new AddTwoNumbersService.Request();
        req.varNumber1 = -3.5;
        req.varNumber2 = 10.25;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<AddTwoNumbersService.Response> responses =
            AddTwoNumbersService.addNumbers(new List<AddTwoNumbersService.Request>{ req });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(6.75, responses[0].varSum, 'Sum of -3.5 and 10.25 should be 6.75.');
    }
}