@IsTest
private class ManavCalculatorTest {
    @IsTest
    static void testAddition_Failing() {
        Integer result = ManavCalculator.add(2, 3);
        
        // This assertion is intentionally wrong
        // The correct result is 5, but we are asserting 6 to make the test fail
        System.assertEquals(6, result, 'This test is designed to fail.');
    }
}