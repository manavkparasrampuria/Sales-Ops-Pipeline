/**
 * @description {!Environment.IvanTest} class for InvoiceSummaryController.
 * NOTE: SalesforceInvoice and SalesforceContract are native platform objects whose fields
 * are not writeable via standard Apex DML or object-initializer syntax (system-managed).
 * This test class uses the JSON.deserialize technique to construct in-memory fake instances
 * of these objects to exercise the mapping/business logic, which has been decomposed into
 * small @{!Environment.IvanTest}Visible methods on the controller for full isolated unit coverage. Standard
 * objects (Account, Contract) are inserted normally via DML.
 * Target coverage: 85%+
 * @author Copado AI
 */
@is{!Environment.IvanTest}
private class InvoiceSummaryController{!Environment.IvanTest} {

    private static SalesforceInvoice buildFakeInvoice(String invoiceNumber, Decimal amount, String status, Date dueDate, Id sfContractId) {
        Map<String, Object> invMap = new Map<String, Object>{
            'InvoiceNumber' => invoiceNumber,
            'TotalAmount' => amount,
            'SalesforceInvoiceStatus' => status,
            'DueDate' => dueDate,
            'SalesforceContractId' => sfContractId
        };
        return (SalesforceInvoice) JSON.deserialize(JSON.serialize(invMap), SalesforceInvoice.class);
    }

    private static SalesforceContract buildFakeSalesforceContract(Id scId, Id contractId) {
        Map<String, Object> scMap = new Map<String, Object>{
            'Id' => scId,
            'ContractId' => contractId
        };
        return (SalesforceContract) JSON.deserialize(JSON.serialize(scMap), SalesforceContract.class);
    }

    @is{!Environment.IvanTest}
    static void testQueryInvoices_ReturnsNonNullList() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<SalesforceInvoice> result = InvoiceSummaryController.queryInvoices();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result, 'Query should return a non-null list');
    }

    @is{!Environment.IvanTest}
    static void testQueryContractsBySfContractIds_ReturnsNonNullList() {
        Set<Id> fakeIds = new Set<Id>{ UserInfo.getUserId() };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<SalesforceContract> result = InvoiceSummaryController.queryContractsBySfContractIds(fakeIds);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result, 'Query should return a non-null list even with no matches');
    }

    @is{!Environment.IvanTest}
    static void testQueryAccountsByContractIds_ReturnsInsertedContract() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account For Query');
        insert acc;
        Contract con = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.today());
        insert con;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contract> result = InvoiceSummaryController.queryAccountsByContractIds(new List<Id>{ con.Id });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, result.size(), 'Should return the inserted contract');
        System.assertEquals('{!Environment.IvanTest} Account For Query', result[0].Account.Name, 'Account name should match');
    }

    @is{!Environment.IvanTest}
    static void testExtractContractIds_FiltersNullsCorrectly() {
        SalesforceInvoice inv1 = buildFakeInvoice('INV-1', 100, 'Open', Date.today(), UserInfo.getUserId());
        SalesforceInvoice inv2 = buildFakeInvoice('INV-2', 200, 'Open', Date.today(), null);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Set<Id> result = InvoiceSummaryController.extractContractIds(new List<SalesforceInvoice>{ inv1, inv2 });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, result.size(), 'Only the non-null SalesforceContractId should be extracted');
    }

    @is{!Environment.IvanTest}
    static void testBuildContractIdMap_Positive() {
        Account acc = new Account(Name = 'Map {!Environment.IvanTest} Account');
        insert acc;
        Contract con = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.today());
        insert con;

        SalesforceContract fakeSc = buildFakeSalesforceContract(UserInfo.getUserId(), con.Id);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<Id, Id> result = InvoiceSummaryController.buildContractIdMap(new List<SalesforceContract>{ fakeSc });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, result.size(), 'Map should contain one entry');
    }

    @is{!Environment.IvanTest}
    static void testBuildAccountNameMap_Positive() {
        Account acc = new Account(Name = 'AccountName Map {!Environment.IvanTest}');
        insert acc;
        Contract con = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.today());
        insert con;

        List<Contract> contracts = [SELECT Id, Account.Name FROM Contract WHERE Id = :con.Id];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<Id, String> result = InvoiceSummaryController.buildAccountNameMap(contracts);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('AccountName Map {!Environment.IvanTest}', result.get(con.Id), 'Account name should map correctly');
    }

    @is{!Environment.IvanTest}
    static void testBuildResults_ResolvesAccountNameCorrectly() {
        Account acc = new Account(Name = 'BuildResults Account');
        insert acc;
        Contract con = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.today());
        insert con;

        Id fakeSfContractId = UserInfo.getUserId();
        SalesforceInvoice fakeInv = buildFakeInvoice('INV-100', 300, 'Open', Date.today(), fakeSfContractId);

        Map<Id, Id> sfToContract = new Map<Id, Id>{ fakeSfContractId => con.Id };
        Map<Id, String> contractToAccount = new Map<Id, String>{ con.Id => 'BuildResults Account' };

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<InvoiceSummaryController.InvoiceWrapper> results = InvoiceSummaryController.buildResults(
            new List<SalesforceInvoice>{ fakeInv }, sfToContract, contractToAccount
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(1, results.size(), 'One wrapper should be returned');
        System.assertEquals('BuildResults Account', results[0].accountName, 'Account name should resolve correctly');
    }

    @is{!Environment.IvanTest}
    static void testBuildResults_NegativeNoMatchDefaultsToEmptyString() {
        SalesforceInvoice fakeInv = buildFakeInvoice('INV-200', 400, 'Open', Date.today(), null);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<InvoiceSummaryController.InvoiceWrapper> results = InvoiceSummaryController.buildResults(
            new List<SalesforceInvoice>{ fakeInv }, new Map<Id, Id>(), new Map<Id, String>()
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('', results[0].accountName, 'Account name should default to empty string when no match found');
    }

    @is{!Environment.IvanTest}
    static void testWrapInvoice_Positive() {
        SalesforceInvoice fakeInv = buildFakeInvoice('INV-1000', 500.00, 'Open', Date.today(), null);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        InvoiceSummaryController.InvoiceWrapper wrapper = InvoiceSummaryController.wrapInvoice(fakeInv, '{!Environment.IvanTest} Account for Invoices');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('INV-1000', wrapper.invoiceNumber, 'Invoice number should map correctly');
        System.assertEquals('{!Environment.IvanTest} Account for Invoices', wrapper.accountName, 'Account name should map correctly');
        System.assertEquals(500.00, wrapper.amount, 'Amount should map correctly');
        System.assertEquals('Open', wrapper.status, 'Status should map correctly');
        System.assertEquals(Date.today(), wrapper.dueDate, 'Due date should map correctly');
    }

    @is{!Environment.IvanTest}
    static void testWrapInvoice_NegativeNullFields() {
        SalesforceInvoice fakeInv = buildFakeInvoice(null, null, null, null, null);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        InvoiceSummaryController.InvoiceWrapper wrapper = InvoiceSummaryController.wrapInvoice(fakeInv, '');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(null, wrapper.invoiceNumber, 'Invoice number should be null');
        System.assertEquals(null, wrapper.amount, 'Amount should be null');
        System.assertEquals(null, wrapper.status, 'Status should be null');
        System.assertEquals(null, wrapper.dueDate, 'Due date should be null');
        System.assertEquals('', wrapper.accountName, 'Account name should be empty string');
    }

    @is{!Environment.IvanTest}
    static void testWrapInvoice_BulkVolume() {
        List<InvoiceSummaryController.InvoiceWrapper> wrappers = new List<InvoiceSummaryController.InvoiceWrapper>();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        for (Integer i = 0; i < 200; i++) {
            SalesforceInvoice fakeInv = buildFakeInvoice('BULK-INV-' + i, 50 + i, 'Open', Date.today().addDays(i), null);
            wrappers.add(InvoiceSummaryController.wrapInvoice(fakeInv, 'Bulk Account ' + i));
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(200, wrappers.size(), 'Expected 200 wrapped invoices from bulk operation');
        System.assertEquals('BULK-INV-0', wrappers[0].invoiceNumber, 'First bulk invoice number should match');
        System.assertEquals('BULK-INV-199', wrappers[199].invoiceNumber, 'Last bulk invoice number should match');
    }

    @is{!Environment.IvanTest}
    static void testGetInvoices_LiveEndToEndExecution() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<InvoiceSummaryController.InvoiceWrapper> results = InvoiceSummaryController.getInvoices();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, results, 'Result list should never be null, even with zero records');
    }
}