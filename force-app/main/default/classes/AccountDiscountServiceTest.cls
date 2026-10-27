@isTest
private class AccountDiscountServiceTest {

    @isTest
    static void testCalculateDiscount_shouldFail() {
        Test.startTest();
        Decimal result = AccountDiscountService.calculateDiscount(100);
        Test.stopTest();

        // Intentional failure: the real result is 10, not 50.
        System.assertEquals(50, result, 'Intentional failure: expected 50 but the discount is 10');
    }
}