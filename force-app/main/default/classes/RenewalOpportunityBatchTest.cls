@Is{!Environment.IvanTest}
private class RenewalOpportunityBatch{!Environment.IvanTest} {
    @{!Environment.IvanTest}Setup
    static void makeData() {
        Account healthyAcc = new Account(Name = 'Healthy Renewal Account', Customer_Health_Score__c = 80);
        Account atRiskAcc = new Account(Name = 'At Risk Renewal Account', Customer_Health_Score__c = 40);
        insert new List<Account>{ healthyAcc, atRiskAcc };

        Contract dueSoon = new Contract(AccountId = healthyAcc.Id, StartDate = Date.today().addDays(-25), ContractTerm = 1,
            Status = 'Draft', Total_ARR__c = 1200, Renewal_Opportunity_Created__c = false);
        Contract atRiskDueSoon = new Contract(AccountId = atRiskAcc.Id, StartDate = Date.today().addDays(-15), ContractTerm = 1,
            Status = 'Draft', Total_ARR__c = 2400, Renewal_Opportunity_Created__c = false);
        Contract notDueYet = new Contract(AccountId = healthyAcc.Id, StartDate = Date.today(), ContractTerm = 7,
            Status = 'Draft', Total_ARR__c = 500, Renewal_Opportunity_Created__c = false);
        Contract alreadyHasRenewal = new Contract(AccountId = healthyAcc.Id, StartDate = Date.today().addDays(-10), ContractTerm = 1,
            Status = 'Draft', Total_ARR__c = 900, Renewal_Opportunity_Created__c = true);
        List<Contract> contracts = new List<Contract>{ dueSoon, atRiskDueSoon, notDueYet, alreadyHasRenewal };
        insert contracts;
        for (Contract con : contracts) { con.Status = 'Activated'; }
        update contracts;
    }

    @Is{!Environment.IvanTest}
    static void testBatch_CreatesRenewalsForDueContractsOnly() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Database.executeBatch(new RenewalOpportunityBatch(), 200);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Opportunity> renewals = [SELECT Id, At_Risk__c FROM Opportunity WHERE Is_Renewal__c = true];
        System.assertEquals(2, renewals.size(), 'Expected renewals only for the two due-soon contracts.');

        Integer createdFlagCount = 0;
        for (Contract con : [SELECT Id, Renewal_Opportunity_Created__c FROM Contract]) {
            if (con.Renewal_Opportunity_Created__c) { createdFlagCount++; }
        }
        System.assertEquals(3, createdFlagCount, 'Two newly created plus the one that already had a renewal.');

        Boolean foundAtRisk = false;
        for (Opportunity opp : renewals) { if (opp.At_Risk__c) { foundAtRisk = true; } }
        System.assert(foundAtRisk, 'Expected at least one renewal flagged At Risk due to low health score.');
    }

    @Is{!Environment.IvanTest}
    static void testBatch_SkipsContractsWithExistingRenewal() {
        Contract existing = [SELECT Id, AccountId FROM Contract WHERE Renewal_Opportunity_Created__c = true LIMIT 1];
        insert new Opportunity(Name = 'Manual Existing Renewal', AccountId = existing.AccountId,
            StageName = 'Prospecting', CloseDate = Date.today().addDays(10),
            Is_Renewal__c = true, Renewal_Source_Contract__c = existing.Id, Renewal_Unique_Key__c = existing.Id);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Database.executeBatch(new RenewalOpportunityBatch(), 200);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Opportunity> renewalsForExisting = [SELECT Id FROM Opportunity WHERE Renewal_Source_Contract__c = :existing.Id];
        System.assertEquals(1, renewalsForExisting.size(), 'Should not create a duplicate renewal.');
    }

    @Is{!Environment.IvanTest}
    static void testScheduler_SchedulesBatchSuccessfully() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String jobId = RenewalOpportunityBatchScheduler.scheduleDaily('0 0 1 * * ?');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, jobId, 'Expected a scheduled job Id to be returned.');
        System.assertEquals(1, [SELECT Id FROM CronTrigger WHERE Id = :jobId].size());
    }
}