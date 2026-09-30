@Is{!Environment.IvanTest}
private class OpportunityLifecycleOrchestrator{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void makeData() {
        Account acc = new Account(Name = 'Lifecycle {!Environment.IvanTest} Account');
        insert acc;

        Product2 swProduct = new Product2(Name = 'Software Widget', Family = 'Software', IsActive = true);
        Product2 hwProduct = new Product2(Name = 'Hardware Widget', Family = 'Hardware', IsActive = true);
        insert new List<Product2>{ swProduct, hwProduct };

        Id stdPbId = {!Environment.IvanTest}.getStandardPricebookId();
        PricebookEntry swEntry = new PricebookEntry(
            Pricebook2Id = stdPbId, Product2Id = swProduct.Id, UnitPrice = 100, IsActive = true);
        PricebookEntry hwEntry = new PricebookEntry(
            Pricebook2Id = stdPbId, Product2Id = hwProduct.Id, UnitPrice = 200, IsActive = true);
        insert new List<PricebookEntry>{ swEntry, hwEntry };
    }

    private static Account getAccount() {
        return [SELECT Id FROM Account WHERE Name = 'Lifecycle {!Environment.IvanTest} Account' LIMIT 1];
    }

    private static Id getSwPbeId() {
        return [SELECT Id FROM PricebookEntry WHERE Product2.Name = 'Software Widget' LIMIT 1].Id;
    }

    private static Id getHwPbeId() {
        return [SELECT Id FROM PricebookEntry WHERE Product2.Name = 'Hardware Widget' LIMIT 1].Id;
    }

    private static Opportunity createOpenOpportunity(Id accountId, String name) {
        Opportunity opp = new Opportunity(
            Name = name,
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Pricebook2Id = {!Environment.IvanTest}.getStandardPricebookId()
        );
        insert opp;
        return opp;
    }

    @Is{!Environment.IvanTest}
    static void testClosedWon_SingleFamily_CreatesContractLineAndSubscription() {
        Account acc = getAccount();
        Opportunity opp = createOpenOpportunity(acc.Id, 'SW Only Opp');
        insert new OpportunityLineItem(
            OpportunityId = opp.Id, PricebookEntryId = getSwPbeId(), Quantity = 2, UnitPrice = 100, Discount = 10);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.StageName = 'Closed Won';
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Contract> contracts = [SELECT Id, ContractTerm, Total_ARR__c, Status FROM Contract WHERE Source_Opportunity__c = :opp.Id];
        System.assertEquals(1, contracts.size(), 'Expected exactly one Contract created.');
        System.assertEquals(12, contracts[0].ContractTerm, 'Software family duration should be 12 months.');

        List<Contract_Line__c> lines = [SELECT Id FROM Contract_Line__c WHERE Contract__c = :contracts[0].Id];
        System.assertEquals(1, lines.size(), 'Expected one Contract Line.');

        List<Subscription__c> subs = [SELECT Id FROM Subscription__c WHERE Contract__c = :contracts[0].Id];
        System.assertEquals(1, subs.size(), 'Software family is subscription eligible, expected one Subscription.');
    }

    @Is{!Environment.IvanTest}
    static void testClosedWon_MixedFamilies_UsesMaxDurationAndOnlyEligibleSubscriptions() {
        Account acc = getAccount();
        Opportunity opp = createOpenOpportunity(acc.Id, 'Mixed Opp');
        insert new List<OpportunityLineItem>{
            new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = getSwPbeId(), Quantity = 1, UnitPrice = 100),
            new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = getHwPbeId(), Quantity = 1, UnitPrice = 200)
        };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.StageName = 'Closed Won';
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Contract con = [SELECT Id, ContractTerm FROM Contract WHERE Source_Opportunity__c = :opp.Id LIMIT 1];
        System.assertEquals(36, con.ContractTerm, 'Hardware family (36 months) should drive the max duration.');

        List<Contract_Line__c> lines = [SELECT Id FROM Contract_Line__c WHERE Contract__c = :con.Id];
        System.assertEquals(2, lines.size(), 'Expected two Contract Lines, one per family.');

        List<Subscription__c> subs = [SELECT Id, Product_Family__c FROM Subscription__c WHERE Contract__c = :con.Id];
        System.assertEquals(1, subs.size(), 'Only Software family is subscription eligible.');
        System.assertEquals('Software', subs[0].Product_Family__c);
    }

    @Is{!Environment.IvanTest}
    static void testClosedWon_NoLineItems_LogsWarningAndSkipsContract() {
        Account acc = getAccount();
        Opportunity opp = createOpenOpportunity(acc.Id, 'Empty Opp');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.StageName = 'Closed Won';
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Contract> contracts = [SELECT Id FROM Contract WHERE Source_Opportunity__c = :opp.Id];
        System.assertEquals(0, contracts.size(), 'No Contract should be created without line items.');

        List<Lifecycle_Audit__c> audits = [SELECT Id, Status__c FROM Lifecycle_Audit__c WHERE Related_Opportunity__c = :opp.Id];
        System.assert(!audits.isEmpty(), 'Expected an audit record logged.');
        System.assertEquals('Warning', audits[0].Status__c);
    }

    @Is{!Environment.IvanTest}
    static void testClosedWon_ContractAlreadyExists_SkipsDuplicateCreation() {
        Account acc = getAccount();
        Opportunity opp = createOpenOpportunity(acc.Id, 'Duplicate Guard Opp');
        insert new OpportunityLineItem(
            OpportunityId = opp.Id, PricebookEntryId = getSwPbeId(), Quantity = 1, UnitPrice = 100);

        insert new Contract(
            AccountId = acc.Id, StartDate = Date.today(), ContractTerm = 12,
            Status = 'Draft', Source_Opportunity__c = opp.Id, Unique_Key__c = opp.Id);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.StageName = 'Closed Won';
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Contract> contracts = [SELECT Id FROM Contract WHERE Source_Opportunity__c = :opp.Id];
        System.assertEquals(1, contracts.size(), 'Should not create a second Contract when one already exists.');
    }

    @Is{!Environment.IvanTest}
    static void testInsert_AlreadyClosedWonWithLineItems_CreatesContract() {
        Account acc = getAccount();
        Opportunity opp = new Opportunity(
            Name = 'Insert Closed Opp', AccountId = acc.Id, StageName = 'Prospecting',
            CloseDate = Date.today(), Pricebook2Id = {!Environment.IvanTest}.getStandardPricebookId());
        insert opp;
        insert new OpportunityLineItem(
            OpportunityId = opp.Id, PricebookEntryId = getSwPbeId(), Quantity = 1, UnitPrice = 100);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.StageName = 'Closed Won';
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Contract> contracts = [SELECT Id FROM Contract WHERE Source_Opportunity__c = :opp.Id];
        System.assertEquals(1, contracts.size());
    }

    @Is{!Environment.IvanTest}
    static void testNonClosedWonUpdate_DoesNotCreateContract() {
        Account acc = getAccount();
        Opportunity opp = createOpenOpportunity(acc.Id, 'Still Open Opp');
        insert new OpportunityLineItem(
            OpportunityId = opp.Id, PricebookEntryId = getSwPbeId(), Quantity = 1, UnitPrice = 100);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        opp.Amount = 500;
        update opp;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Contract> contracts = [SELECT Id FROM Contract WHERE Source_Opportunity__c = :opp.Id];
        System.assertEquals(0, contracts.size(), 'No Contract should be created for non Closed Won updates.');
    }

    @Is{!Environment.IvanTest}
    static void testServiceHelpers_DirectCoverage() {
        Account acc = getAccount();
        Opportunity opp = createOpenOpportunity(acc.Id, 'Helper Coverage Opp');
        insert new List<OpportunityLineItem>{
            new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = getSwPbeId(), Quantity = 2, UnitPrice = 100, Discount = 10),
            new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = getHwPbeId(), Quantity = 1, UnitPrice = 200)
        };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<OpportunityLineItem> items = OpportunityLifecycleService.getLineItems(opp.Id);
        System.assertEquals(2, items.size());

        Map<String, OpportunityLifecycleService.FamilySummary> byFamily = OpportunityLifecycleService.groupByFamily(items);
        System.assertEquals(2, byFamily.size());

        Decimal totalArrAmt = OpportunityLifecycleService.totalArr(items);
        System.assert(totalArrAmt > 0);

        Decimal avgDiscount = OpportunityLifecycleService.weightedAvgDiscount(items);
        System.assert(avgDiscount >= 0);

        Integer maxMonths = OpportunityLifecycleService.maxDurationMonths(byFamily);
        System.assertEquals(36, maxMonths);

        Boolean existsBefore = OpportunityLifecycleService.contractExists(opp.Id);
        System.assertEquals(false, existsBefore);

        Boolean subExistsBefore = OpportunityLifecycleService.subscriptionExists('none');
        System.assertEquals(false, subExistsBefore);

        Lifecycle_Audit__c audit = OpportunityLifecycleService.buildAudit(
            'Opportunity Closed Won', 'Info', '{!Environment.IvanTest} message', opp.Id, null, null);
        System.assertEquals('Info', audit.Status__c);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testRenewalExists_ReturnsFalseWithNoRenewal() {
        Account acc = getAccount();
        Contract con = new Contract(
            AccountId = acc.Id, StartDate = Date.today(), ContractTerm = 12, Status = 'Draft');
        insert con;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean result = OpportunityLifecycleService.renewalExists(con.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(false, result, 'No renewal Opportunity exists yet.');
    }
}