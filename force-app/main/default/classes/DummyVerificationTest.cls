@isTest
private class DummyVerificationTest {
    @isTest
    static void testDummyAssertion() {
        Integer expected = 2;
        Integer actual = 1 + 1;
        System.assertEquals(expected, actual, 'Basic sanity check should pass.');
    }
}