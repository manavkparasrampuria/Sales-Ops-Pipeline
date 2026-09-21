// ─────────────────────────────────────────
// {!Environment.IvanTest} 1: AccountHelper{!Environment.IvanTest} — FAILS + Low Coverage
// ─────────────────────────────────────────
@Is{!Environment.IvanTest}(critical=true)
private class AccountHelper{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGetAccountPriority_High() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Corp', AnnualRevenue = 2000000);

        String result = AccountHelper.getAccountPriority(acc);

        // FAIL — expecting wrong value
        System.assertEquals('Low', result, 'Expected High priority but got something else');
    }
}