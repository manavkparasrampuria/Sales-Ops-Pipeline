// ─────────────────────────────────────────
// {!Environment.IvanTest} 2: OpportunityHelper{!Environment.IvanTest} — FAILS + Low Coverage
// ─────────────────────────────────────────
@Is{!Environment.IvanTest}(critical=true)
private class OpportunityHelper{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGetDealStage_Enterprise() {
        Opportunity opp = new Opportunity(
            Name = 'Big Deal',
            Amount = 600000,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );

        String result = OpportunityHelper.getDealStage(opp);

        // FAIL — expecting wrong value
        System.assertEquals('Small Deal', result, 'Expected Enterprise Deal but got something else');
    }
}