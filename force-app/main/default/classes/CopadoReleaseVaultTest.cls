@Is{!Environment.IvanTest}(critical=true)
private class CopadoReleaseVault{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Account acc = new Account(Name = 'Copado Demo Account');
        insert acc;
    }

    // ❌ FAILS — wrong expected value intentionally
    // Class marked @Is{!Environment.IvanTest}(critical=true) — RunRelevant{!Environment.IvanTest}s ALWAYS picks up this entire test class
    @Is{!Environment.IvanTest}
    static void verifyCopadoDiscountEngine() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Decimal result = CopadoReleaseVault.applyCopadoDiscount(200, 10);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        // Intentionally wrong — expects 30 but result is 20 → TEST FAILS
        System.assertEquals(30, result,
            'Expected discount to be 30 but got: ' + result);
    }

    // ❌ FAILS — wrong expected value intentionally
    @Is{!Environment.IvanTest}
    static void confirmBlazeAccountNameTransform() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = CopadoReleaseVault.blazeAccountName('copado');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        // Intentionally wrong — expects 'copado' but result is 'COPADO' → TEST FAILS
        System.assertEquals('copado', result,
            'Expected name to remain lowercase but got: ' + result);
    }
}