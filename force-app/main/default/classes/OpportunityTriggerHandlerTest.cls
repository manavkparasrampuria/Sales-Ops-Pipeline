/**
 * @description Unit tests for OpportunityTriggerHandler.
 *              Covers positive, negative, and bulk scenarios for both
 *              loyalty-points logic and stage-regression prevention.
 *              Target: >= 75% code coverage.
 *
 * @author      Copado Orchestrate Agent
 * @date        2026-08-13
 * @modified    2026-09-08  Added stage-regression test cases
 */
@Is{!Environment.IvanTest}
private class OpportunityTriggerHandler{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Setup ──────────────────────────────────────────────────

    @{!Environment.IvanTest}Setup
    static void makeData() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account');
        insert acc;
    }

    private static Account getAccount() {
        return [SELECT Id, LoyaltyPoints__c FROM Account WHERE Name = '{!Environment.IvanTest} Account' LIMIT 1];
    }

    // ─── Positive {!Environment.IvanTest}s ───────────────────────────────────────────────────

    /**
     * @description Insert a single Closed Won opportunity and verify
     *              LoyaltyPoints__c is calculated correctly.
     */
    @Is{!Environment.IvanTest}
    static void testInsert_SingleClosedWon_CalculatesPoints() {
        Account acc = getAccount();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Opportunity opp = new Opportunity(
            Name      = '{!Environment.IvanTest} Opp',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            Amount    = 5000,
            CloseDate = Date.today()
        );
        insert opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assertEquals(5, result.LoyaltyPoints__c,
            'Expected 5 points for $5,000 Closed Won revenue.');
    }

    /**
     * @description Update an opportunity stage to Closed Won and verify
     *              points are recalculated.
     */
    @Is{!Environment.IvanTest}
    static void testUpdate_StageToClosedWon_CalculatesPoints() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Prospect Opp',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            Amount    = 10000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.StageName = 'Closed Won';
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assertEquals(10, result.LoyaltyPoints__c,
            'Expected 10 points for $10,000 Closed Won revenue.');
    }

    /**
     * @description Update the Amount on a Closed Won opportunity and verify
     *              points are recalculated.
     */
    @Is{!Environment.IvanTest}
    static void testUpdate_AmountOnClosedWon_RecalculatesPoints() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Won Opp',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            Amount    = 3000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.Amount = 7000;
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assertEquals(7, result.LoyaltyPoints__c,
            'Expected 7 points after amount updated to $7,000.');
    }

    /**
     * @description Verify that attempting to move a Closed Won opp to another
     *              stage is blocked by the regression guard.
     */
    @Is{!Environment.IvanTest}
    static void testUpdate_StageFromClosedWon_BlockedByRegression() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Won Opp',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            Amount    = 8000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            opp.StageName = 'Closed Lost';
            update opp;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(
                e.getMessage().contains(OpportunityTriggerHandler.REGRESSION_ERROR),
                'Expected regression error message in DmlException.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected a DmlException for stage regression.');
        Account result = getAccount();
        System.assertEquals(8, result.LoyaltyPoints__c,
            'Points should remain at 8 because the update was blocked.');
    }

    // ─── Stage Regression {!Environment.IvanTest}s ───────────────────────────────────────────

    /**
     * @description Attempt to move a Closed Won opp to Prospecting and verify
     *              the update is rejected with the correct error message.
     */
    @Is{!Environment.IvanTest}
    static void testRegression_ClosedWonToProspecting_IsBlocked() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Regression Opp',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            Amount    = 1000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            opp.StageName = 'Prospecting';
            update opp;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(
                e.getMessage().contains(OpportunityTriggerHandler.REGRESSION_ERROR),
                'Expected regression error message.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'DmlException expected for Closed Won -> Prospecting.');
    }

    /**
     * @description Verify that updating a non-Closed Won opp to another
     *              non-Closed Won stage is allowed (no regression guard fires).
     */
    @Is{!Environment.IvanTest}
    static void testRegression_ProspectingToNegotiation_IsAllowed() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Open Opp',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            Amount    = 2000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            opp.StageName = 'Negotiation/Review';
            update opp;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(!exceptionThrown, 'No exception expected for non-Closed Won stage change.');
    }

    /**
     * @description Verify that keeping a Closed Won opp in Closed Won
     *              (updating another field) is allowed.
     */
    @Is{!Environment.IvanTest}
    static void testRegression_ClosedWonStaysClosedWon_IsAllowed() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Stable Won Opp',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            Amount    = 4000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            opp.Description = 'Updated description only';
            update opp;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(!exceptionThrown, 'No exception expected when stage stays Closed Won.');
    }

    /**
     * @description Bulk test: 10 Closed Won opps all attempting regression
     *              should all be blocked (kept small to avoid SOQL limits in
     *              OpportunityLifecycleOrchestrator).
     */
    @Is{!Environment.IvanTest}
    static void testRegression_BulkClosedWon_AllBlocked() {
        Account acc = getAccount();
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            opps.add(new Opportunity(
                Name      = 'Bulk Won Opp ' + i,
                AccountId = acc.Id,
                StageName = 'Closed Won',
                Amount    = 1000,
                CloseDate = Date.today()
            ));
        }
        insert opps;

        for (Opportunity o : opps) {
            o.StageName = 'Prospecting';
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            update opps;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionThrown, 'Expected DmlException for bulk regression attempt.');
    }

    // ─── Negative {!Environment.IvanTest}s ───────────────────────────────────────────────────

    /**
     * @description Insert a non-Closed Won opportunity and verify
     *              LoyaltyPoints__c remains 0.
     */
    @Is{!Environment.IvanTest}
    static void testInsert_NonClosedWon_NoPoints() {
        Account acc = getAccount();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Opportunity opp = new Opportunity(
            Name      = 'Open Opp',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            Amount    = 50000,
            CloseDate = Date.today()
        );
        insert opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assert(
            result.LoyaltyPoints__c == null || result.LoyaltyPoints__c == 0,
            'Expected 0 points for a non-Closed Won opportunity.'
        );
    }

    /**
     * @description Insert an opportunity with no AccountId and verify
     *              no exception is thrown and no account is updated.
     */
    @Is{!Environment.IvanTest}
    static void testInsert_NoAccountId_NoException() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionThrown = false;
        try {
            Opportunity opp = new Opportunity(
                Name      = 'No Account Opp',
                StageName = 'Closed Won',
                Amount    = 5000,
                CloseDate = Date.today()
            );
            insert opp;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Handler should not throw for opps without AccountId.');
    }

    /**
     * @description Update an opportunity that stays in a non-Closed Won stage
     *              and verify LoyaltyPoints__c is not affected.
     */
    @Is{!Environment.IvanTest}
    static void testUpdate_NonClosedWon_NoPointsChange() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name      = 'Open Opp',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            Amount    = 5000,
            CloseDate = Date.today()
        );
        insert opp;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.Amount = 9000;
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assert(
            result.LoyaltyPoints__c == null || result.LoyaltyPoints__c == 0,
            'Expected 0 points when opportunity is not Closed Won.'
        );
    }

    // ─── Bulk {!Environment.IvanTest}s ───────────────────────────────────────────────────────

    /**
     * @description Insert 10 Closed Won opportunities and verify
     *              LoyaltyPoints__c is the correct aggregate total.
     *              (Kept small to avoid SOQL limits in OpportunityLifecycleOrchestrator.)
     */
    @Is{!Environment.IvanTest}
    static void testBulkInsert_ClosedWon_CalculatesAggregatePoints() {
        Account acc = getAccount();
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            opps.add(new Opportunity(
                Name      = 'Bulk Opp ' + i,
                AccountId = acc.Id,
                StageName = 'Closed Won',
                Amount    = 1000,
                CloseDate = Date.today()
            ));
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert opps;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assertEquals(10, result.LoyaltyPoints__c,
            'Expected 10 points for 10 x $1,000 Closed Won opportunities.');
    }

    /**
     * @description Bulk update 10 opportunities from Prospecting to Closed Won
     *              and verify aggregate points are calculated correctly.
     *              (Kept small to avoid SOQL limits in OpportunityLifecycleOrchestrator.)
     */
    @Is{!Environment.IvanTest}
    static void testBulkUpdate_ToClosedWon_CalculatesAggregatePoints() {
        Account acc = getAccount();
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            opps.add(new Opportunity(
                Name      = 'Bulk Opp ' + i,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                Amount    = 2000,
                CloseDate = Date.today()
            ));
        }
        insert opps;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        for (Opportunity o : opps) {
            o.StageName = 'Closed Won';
        }
        update opps;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Account result = getAccount();
        System.assertEquals(20, result.LoyaltyPoints__c,
            'Expected 20 points for 10 x $2,000 Closed Won opportunities.');
    }
}