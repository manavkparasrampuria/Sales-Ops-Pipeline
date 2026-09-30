/**
 * @description Unit tests for AddThreeNumbersService (US-0020774).
 *              Covers the happy path, all three null-input fault paths,
 *              negative numbers, and decimal precision to meet the 75 % minimum
 *              coverage requirement defined on the user story.
 *
 * @author      Ashok Kosinepalli
 * @story       US-0020774
 * @date        2026-09-08
 */
@is{!Environment.IvanTest}
private class AddThreeNumbersService{!Environment.IvanTest} {

    // ─── Happy Path ───────────────────────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testValidPositiveIntegersReturnCorrectSum() {
        AddThreeNumbersService.Request req = new AddThreeNumbersService.Request();
        req.varNumber1 = 2;
        req.varNumber2 = 3;
        req.varNumber3 = 5;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<AddThreeNumbersService.Response> responses =
            AddThreeNumbersService.addNumbers(
                new List<AddThreeNumbersService.Request>{ req }
            );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, responses.size(), 'Expected exactly one response.');
        System.assertEquals(10, responses[0].varSum, 'Sum of 2, 3, and 5 should be 10.');
    }

    @is{!Environment.IvanTest}
    static void testNegativeAndDecimalNumbersReturnCorrectSum() {
        AddThreeNumbersService.Request req = new AddThreeNumbersService.Request();
        req.varNumber1 = -1.5;
        req.varNumber2 = 4.25;
        req.varNumber3 = 2.0;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<AddThreeNumbersService.Response> responses =
            AddThreeNumbersService.addNumbers(
                new List<AddThreeNumbersService.Request>{ req }
            );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(4.75, responses[0].varSum, 'Sum of -1.5, 4.25, and 2.0 should be 4.75.');
    }

    @is{!Environment.IvanTest}
    static void testMultipleRequestsInSingleInvocation() {
        AddThreeNumbersService.Request req1 = new AddThreeNumbersService.Request();
        req1.varNumber1 = 1;
        req1.varNumber2 = 2;
        req1.varNumber3 = 3;

        AddThreeNumbersService.Request req2 = new AddThreeNumbersService.Request();
        req2.varNumber1 = 10;
        req2.varNumber2 = 20;
        req2.varNumber3 = 30;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<AddThreeNumbersService.Response> responses =
            AddThreeNumbersService.addNumbers(
                new List<AddThreeNumbersService.Request>{ req1, req2 }
            );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(2, responses.size(), 'Expected two responses for two requests.');
        System.assertEquals(6,  responses[0].varSum, 'First sum should be 6.');
        System.assertEquals(60, responses[1].varSum, 'Second sum should be 60.');
    }

    // ─── Null-Input Fault Paths ───────────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testNullFirstNumberThrowsException() {
        AddThreeNumbersService.Request req = new AddThreeNumbersService.Request();
        req.varNumber1 = null;
        req.varNumber2 = 3;
        req.varNumber3 = 5;

        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AddThreeNumbersService.addNumbers(
                new List<AddThreeNumbersService.Request>{ req }
            );
        } catch (AddThreeNumbersService.AddThreeNumbersException ex) {
            exceptionThrown = true;
            System.assertEquals(
                'All three numbers are required to calculate a sum.',
                ex.getMessage(),
                'Exception message should match the expected text.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected an exception when the first number is null.');
    }

    @is{!Environment.IvanTest}
    static void testNullSecondNumberThrowsException() {
        AddThreeNumbersService.Request req = new AddThreeNumbersService.Request();
        req.varNumber1 = 2;
        req.varNumber2 = null;
        req.varNumber3 = 5;

        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AddThreeNumbersService.addNumbers(
                new List<AddThreeNumbersService.Request>{ req }
            );
        } catch (AddThreeNumbersService.AddThreeNumbersException ex) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected an exception when the second number is null.');
    }

    @is{!Environment.IvanTest}
    static void testNullThirdNumberThrowsException() {
        AddThreeNumbersService.Request req = new AddThreeNumbersService.Request();
        req.varNumber1 = 2;
        req.varNumber2 = 3;
        req.varNumber3 = null;

        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            AddThreeNumbersService.addNumbers(
                new List<AddThreeNumbersService.Request>{ req }
            );
        } catch (AddThreeNumbersService.AddThreeNumbersException ex) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected an exception when the third number is null.');
    }
}