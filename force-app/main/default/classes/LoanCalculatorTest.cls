@Is{!Environment.IvanTest}
private class LoanCalculator{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        // No DML needed for pure calculation tests
    }

    @Is{!Environment.IvanTest}
    static void testMonthlyPaymentStandardLoan() {
        Decimal result = LoanCalculator.calculateMonthlyPayment(10000, 5.5, 24);
        System.assertNotEquals(null, result, 'Monthly payment should not be null');
        System.assert(result > 0, 'Monthly payment should be positive');
    }

    @Is{!Environment.IvanTest}
    static void testMonthlyPaymentZeroInterest() {
        Decimal result = LoanCalculator.calculateMonthlyPayment(12000, 0, 12);
        System.assertEquals(1000.00, result, 'Zero interest: monthly payment should be principal / term');
    }

    @Is{!Environment.IvanTest}
    static void testTotalRepayment() {
        Decimal result = LoanCalculator.calculateTotalRepayment(10000, 5.5, 24);
        System.assert(result > 10000, 'Total repayment should exceed principal');
    }

    @Is{!Environment.IvanTest}
    static void testTotalInterest() {
        Decimal interest = LoanCalculator.calculateTotalInterest(10000, 5.5, 24);
        System.assert(interest > 0, 'Total interest should be positive');
    }

    @Is{!Environment.IvanTest}
    static void testInvalidPrincipal() {
        try {
            LoanCalculator.calculateMonthlyPayment(-5000, 5.5, 12);
            System.assert(false, 'Expected exception was not thrown');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Invalid'), 'Exception message should mention invalid parameters');
        }
    }

    @Is{!Environment.IvanTest}
    static void testInvalidTermMonths() {
        try {
            LoanCalculator.calculateMonthlyPayment(10000, 5.5, 0);
            System.assert(false, 'Expected exception was not thrown');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Invalid'), 'Exception message should mention invalid parameters');
        }
    }

    @Is{!Environment.IvanTest}
    static void testBulkCalculations() {
        List<Decimal> results = new List<Decimal>();
        for (Integer i = 1; i <= 200; i++) {
            results.add(LoanCalculator.calculateMonthlyPayment(i * 1000, 4.5, 36));
        }
        System.assertEquals(200, results.size(), 'Should handle 200 bulk calculations');
    }
}