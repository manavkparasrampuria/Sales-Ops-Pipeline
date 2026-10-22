/**
 * @description DEMO ONLY. This version of the test class is deliberately broken.
 *              1) getOpenCases_wrongExpectation FAILS on purpose.
 *              2) markCasesHighPriority is NOT tested, so its lines are uncovered
 *                 and manavOct1 coverage drops.
 *              Restore the original manavOct1Test before committing.
 */
@IsTest
private class manavOct1Test {

    @TestSetup
    static void setup() {
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 20; i++) {
            cases.add(new Case(
                Subject = 'Test case ' + i,
                Status = 'New',
                Priority = 'Low',
                Origin = 'Web'
            ));
        }
        insert cases;
    }

    @IsTest
    static void getOpenCases_returnsRequestedNumber() {
        Test.startTest();
        List<Case> result = manavOct1.getOpenCases(5);
        Test.stopTest();

        System.assertEquals(5, result.size(), 'Should return the requested number of open cases');
    }

    // INTENTIONAL FAILURE: 20 open cases exist, but this asserts 999.
    @IsTest
    static void getOpenCases_wrongExpectation() {
        Test.startTest();
        List<Case> result = manavOct1.getOpenCases(200);
        Test.stopTest();

        System.assertEquals(999, result.size(), 'Intentional failure: expected count is wrong');
    }

    // markCasesHighPriority is intentionally not tested here, to lower coverage.
}