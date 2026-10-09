// ─────────────────────────────────────────
// Test 1: AccountHelperTest — FAILS + Low Coverage
// ─────────────────────────────────────────
@IsTest(critical=true)
private class AccountHelperTest {

    @IsTest
    static void testGetAccountPriority_High() {
        Account acc = new Account(Name = 'Test Corp', AnnualRevenue = 2000000);

        String result = AccountHelper.getAccountPriority(acc);

        // FAIL — expecting wrong value
        System.assertEquals('Low', result, 'Expected High priority but got something else');
    }
}