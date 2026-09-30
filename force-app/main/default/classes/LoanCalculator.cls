public with sharing class LoanCalculator {

    /**
     * Calculates the monthly repayment amount for a loan.
     * @param principal  - The total loan amount
     * @param annualRate - Annual interest rate as a percentage (e.g. 5.5 for 5.5%)
     * @param termMonths - Loan duration in months
     * @return           - Monthly repayment amount
     */
    public static Decimal calculateMonthlyPayment(Decimal principal, Decimal annualRate, Integer termMonths) {
        if (principal <= 0 || annualRate < 0 || termMonths <= 0) {
            throw new IllegalArgumentException('Invalid loan parameters provided.');
        }

        if (annualRate == 0) {
            return principal / termMonths;
        }

        Decimal monthlyRate = (annualRate / 100) / 12;
        Decimal factor = (1 + monthlyRate).pow(termMonths);
        Decimal monthlyPayment = principal * (monthlyRate * factor) / (factor - 1);

        return monthlyPayment.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the total repayment amount over the full loan term.
     */
    public static Decimal calculateTotalRepayment(Decimal principal, Decimal annualRate, Integer termMonths) {
        Decimal monthly = calculateMonthlyPayment(principal, annualRate, termMonths);
        return (monthly * termMonths).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the total interest paid over the loan term.
     */
    public static Decimal calculateTotalInterest(Decimal principal, Decimal annualRate, Integer termMonths) {
        Decimal totalRepayment = calculateTotalRepayment(principal, annualRate, termMonths);
        return (totalRepayment - principal).setScale(2, RoundingMode.HALF_UP);
    }
}