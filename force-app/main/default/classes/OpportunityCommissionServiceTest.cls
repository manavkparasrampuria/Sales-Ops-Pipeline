/**
 * OpportunityCommissionService{!Environment.IvanTest}
 *
 * Unit tests for OpportunityCommissionService. All Opportunity instances
 * used here are constructed purely in memory (no insert/DML), since the
 * service under test is a stateless calculation utility that does not
 * require persisted records.
 */
@is{!Environment.IvanTest}
private class OpportunityCommissionService{!Environment.IvanTest} {

    private static final String CLOSED_WON = 'Closed Won';

    @is{!Environment.IvanTest}
    static void testBelowFirstTierBoundary() {
        Opportunity opp = new Opportunity(Amount = 49999.99, StageName = CLOSED_WON);
        Decimal expected = (49999.99 * 0.03).setScale(2, System.RoundingMode.HALF_UP);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(expected, result, 'Amount just below 50,000 should use the 3% tier.');
    }

    @is{!Environment.IvanTest}
    static void testExactLowerBoundaryOfSecondTier() {
        Opportunity opp = new Opportunity(Amount = 50000, StageName = CLOSED_WON);
        Decimal expected = (50000 * 0.05).setScale(2, System.RoundingMode.HALF_UP);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(expected, result, 'Amount exactly at 50,000 should use the 5% tier.');
    }

    @is{!Environment.IvanTest}
    static void testJustBelowThirdTierBoundary() {
        Opportunity opp = new Opportunity(Amount = 99999.99, StageName = CLOSED_WON);
        Decimal expected = (99999.99 * 0.05).setScale(2, System.RoundingMode.HALF_UP);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(expected, result, 'Amount just below 100,000 should still use the 5% tier.');
    }

    @is{!Environment.IvanTest}
    static void testExactUpperBoundary() {
        Opportunity opp = new Opportunity(Amount = 100000, StageName = CLOSED_WON);
        Decimal expected = (100000 * 0.08).setScale(2, System.RoundingMode.HALF_UP);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(expected, result, 'Amount exactly at 100,000 should use the 8% tier.');
    }

    @is{!Environment.IvanTest}
    static void testWellAboveUpperBoundary() {
        Opportunity opp = new Opportunity(Amount = 500000, StageName = CLOSED_WON);
        Decimal expected = (500000 * 0.08).setScale(2, System.RoundingMode.HALF_UP);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(expected, result, 'Amount well above 100,000 should use the 8% tier.');
    }

    @is{!Environment.IvanTest}
    static void testNonClosedWonStageReturnsZero() {
        Opportunity opp1 = new Opportunity(Amount = 250000, StageName = 'Prospecting');
        Opportunity opp2 = new Opportunity(Amount = 75000, StageName = 'Negotiation/Review');

        System.assertEquals(0, OpportunityCommissionService.calculateCommission(opp1),
            'Non Closed Won stage should return 0 commission regardless of amount.');
        System.assertEquals(0, OpportunityCommissionService.calculateCommission(opp2),
            'Non Closed Won stage should return 0 commission regardless of amount.');
    }

    @is{!Environment.IvanTest}
    static void testNullAmountWithClosedWonReturnsZero() {
        Opportunity opp = new Opportunity(Amount = null, StageName = CLOSED_WON);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(0, result, 'A null Amount should be treated as zero and not throw an exception.');
    }

    @is{!Environment.IvanTest}
    static void testNullOpportunityReturnsZero() {
        Decimal result = OpportunityCommissionService.calculateCommission(null);

        System.assertEquals(0, result, 'A null Opportunity reference should safely return 0.');
    }

    @is{!Environment.IvanTest}
    static void testNullStageNameReturnsZero() {
        Opportunity opp = new Opportunity(Amount = 60000);

        Decimal result = OpportunityCommissionService.calculateCommission(opp);

        System.assertEquals(0, result, 'A null StageName should be treated as not Closed Won.');
    }

    @is{!Environment.IvanTest}
    static void testBulkMapMethodMixedStagesAndTiers() {
        Opportunity opp1 = new Opportunity(Id = fflib_IdGeneratorStub(1), Amount = 25000, StageName = CLOSED_WON);
        Opportunity opp2 = new Opportunity(Id = fflib_IdGeneratorStub(2), Amount = 75000, StageName = CLOSED_WON);
        Opportunity opp3 = new Opportunity(Id = fflib_IdGeneratorStub(3), Amount = 150000, StageName = CLOSED_WON);
        Opportunity opp4 = new Opportunity(Id = fflib_IdGeneratorStub(4), Amount = 150000, StageName = 'Prospecting');
        Opportunity opp5 = new Opportunity(Id = fflib_IdGeneratorStub(5), Amount = null, StageName = CLOSED_WON);

        List<Opportunity> opps = new List<Opportunity>{ opp1, opp2, opp3, opp4, opp5 };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<Id, Decimal> results = OpportunityCommissionService.calculateCommissions(opps);
        Integer queryCountBefore = Limits.getQueries();
        Integer dmlCountBefore = Limits.getDmlStatements();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(5, results.size(), 'All opportunities should have a commission entry.');
        System.assertEquals((25000 * 0.03).setScale(2, System.RoundingMode.HALF_UP), results.get(opp1.Id));
        System.assertEquals((75000 * 0.05).setScale(2, System.RoundingMode.HALF_UP), results.get(opp2.Id));
        System.assertEquals((150000 * 0.08).setScale(2, System.RoundingMode.HALF_UP), results.get(opp3.Id));
        System.assertEquals(0, results.get(opp4.Id), 'Non Closed Won stage should return 0 regardless of amount.');
        System.assertEquals(0, results.get(opp5.Id), 'Null amount should return 0.');

        System.assertEquals(0, queryCountBefore, 'The service must not perform any SOQL queries.');
        System.assertEquals(0, dmlCountBefore, 'The service must not perform any DML statements.');
    }

    @is{!Environment.IvanTest}
    static void testBulkListMethodPreservesOrder() {
        Opportunity opp1 = new Opportunity(Amount = 10000, StageName = CLOSED_WON);
        Opportunity opp2 = new Opportunity(Amount = 60000, StageName = CLOSED_WON);
        Opportunity opp3 = new Opportunity(Amount = 120000, StageName = CLOSED_WON);

        List<Opportunity> opps = new List<Opportunity>{ opp1, opp2, opp3 };

        List<Decimal> results = OpportunityCommissionService.calculateCommissionsList(opps);

        System.assertEquals(3, results.size());
        System.assertEquals((10000 * 0.03).setScale(2, System.RoundingMode.HALF_UP), results[0]);
        System.assertEquals((60000 * 0.05).setScale(2, System.RoundingMode.HALF_UP), results[1]);
        System.assertEquals((120000 * 0.08).setScale(2, System.RoundingMode.HALF_UP), results[2]);
    }

    @is{!Environment.IvanTest}
    static void testBulkMethodsHandleNullAndEmptyList() {
        System.assertEquals(0, OpportunityCommissionService.calculateCommissions(null).size());
        System.assertEquals(0, OpportunityCommissionService.calculateCommissions(new List<Opportunity>()).size());
        System.assertEquals(0, OpportunityCommissionService.calculateCommissionsList(null).size());
        System.assertEquals(0, OpportunityCommissionService.calculateCommissionsList(new List<Opportunity>()).size());
    }

    /**
     * Generates a deterministic fake Id for an sObject type without
     * performing any DML, used purely to allow map keying in bulk tests.
     */
    private static Id fflib_IdGeneratorStub(Integer counter) {
        String prefix = '006';
        String suffix = String.valueOf(counter).leftPad(12, '0');
        return Id.valueOf(prefix + suffix);
    }
}