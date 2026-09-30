/**
 * @class       NMD_OrderSubmissionManager{!Environment.IvanTest}
 * @description Unit tests for NMD_OrderSubmissionManager.
 *              Covers: split-serial logic, standard single-surgery logic,
 *              mixed order items, edge cases (blank/short serial, null orderId),
 *              and bulk scenarios.
 *
 * @author      Copado Build Agent
 * @date        2026-08-09
 */
@Is{!Environment.IvanTest}
private class NMD_OrderSubmissionManager{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Setup ──────────────────────────────────────────────────────

    /**
     * @description Creates a minimal but valid Order with a Pricebook, Product,
     *              and PricebookEntry so Order Items can be inserted.
     *              The productCode parameter controls which model number is used.
     */
    private static Order create{!Environment.IvanTest}Order() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account');
        insert acc;

        Order ord = new Order(
            AccountId     = acc.Id,
            Status        = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id  = {!Environment.IvanTest}.getStandardPricebookId()
        );
        insert ord;
        return ord;
    }

    private static OrderItem createOrderItem(
        Id     orderId,
        String productCode,
        String serialNumber
    ) {
        Product2 prod = new Product2(
            Name        = 'SCS Product',
            ProductCode = productCode,
            IsActive    = true
        );
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = {!Environment.IvanTest}.getStandardPricebookId(),
            Product2Id   = prod.Id,
            UnitPrice    = 100.00,
            IsActive     = true
        );
        insert pbe;

        OrderItem item = new OrderItem(
            OrderId          = orderId,
            PricebookEntryId = pbe.Id,
            Quantity         = 1,
            UnitPrice        = 100.00,
            Serial_Number__c = serialNumber
        );
        insert item;
        return item;
    }

    // ─── {!Environment.IvanTest} Methods ─────────────────────────────────────────────────────────

    /**
     * Null orderId should exit gracefully without any DML or exception.
     */
    @Is{!Environment.IvanTest}
    static void testNullOrderIdDoesNothing() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [SELECT Id FROM Surgery__c];
        System.assertEquals(0, surgeries.size(),
            'No Surgery records should be created for a null Order Id.');
    }

    /**
     * A standard (non-split) model number should produce exactly 1 Surgery
     * record with the full serial number.
     */
    @Is{!Environment.IvanTest}
    static void testSingleSurgeryForStandardModel() {
        Order ord = create{!Environment.IvanTest}Order();
        createOrderItem(ord.Id, 'MODEL-STANDARD', '1234567890');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(ord.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [
            SELECT Serial_Number__c, Order_Item__c
            FROM   Surgery__c
            WHERE  Order__c = :ord.Id
        ];
        System.assertEquals(1, surgeries.size(),
            'Exactly 1 Surgery record should be created for a standard model.');
        System.assertEquals('1234567890', surgeries[0].Serial_Number__c,
            'Full serial number should be stamped on the Surgery record.');
    }

    /**
     * The split model number should produce exactly 2 Surgery records,
     * with the serial split into two 5-char halves.
     */
    @Is{!Environment.IvanTest}
    static void testDualSurgeryWithSerialSplitForSplitModel() {
        Order ord = create{!Environment.IvanTest}Order();
        createOrderItem(ord.Id, NMD_OrderSubmissionManager.SPLIT_MODEL_NUMBER, '1234567890');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(ord.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [
            SELECT Serial_Number__c
            FROM   Surgery__c
            WHERE  Order__c = :ord.Id
            ORDER BY Serial_Number__c ASC
        ];
        System.assertEquals(2, surgeries.size(),
            'Exactly 2 Surgery records should be created for the split model.');

        Set<String> serials = new Set<String>();
        for (Surgery__c s : surgeries) {
            serials.add(s.Serial_Number__c);
        }
        System.assert(serials.contains('12345'),
            'First half of serial (12345) should be on one Surgery record.');
        System.assert(serials.contains('67890'),
            'Second half of serial (67890) should be on one Surgery record.');
    }

    /**
     * Mixed order: one split-model item and one standard item.
     * Expected: 3 Surgery records total (2 + 1).
     */
    @Is{!Environment.IvanTest}
    static void testMixedOrderItemsProduceCorrectSurgeryCount() {
        Order ord = create{!Environment.IvanTest}Order();
        createOrderItem(ord.Id, NMD_OrderSubmissionManager.SPLIT_MODEL_NUMBER, '1234567890');
        createOrderItem(ord.Id, 'MODEL-STANDARD', 'ABCDE12345');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(ord.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [
            SELECT Id FROM Surgery__c WHERE Order__c = :ord.Id
        ];
        System.assertEquals(3, surgeries.size(),
            'Mixed order should produce 3 Surgery records (2 split + 1 standard).');
    }

    /**
     * Split model with a blank serial number: 2 Surgery records should still
     * be created, both with null serial numbers (graceful degradation).
     */
    @Is{!Environment.IvanTest}
    static void testSplitModelWithBlankSerialCreatesRecordsWithNullSerial() {
        Order ord = create{!Environment.IvanTest}Order();
        createOrderItem(ord.Id, NMD_OrderSubmissionManager.SPLIT_MODEL_NUMBER, null);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(ord.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [
            SELECT Serial_Number__c
            FROM   Surgery__c
            WHERE  Order__c = :ord.Id
        ];
        System.assertEquals(2, surgeries.size(),
            '2 Surgery records should be created even when serial is blank.');
        for (Surgery__c s : surgeries) {
            System.assertEquals(null, s.Serial_Number__c,
                'Serial number should be null when source serial is blank.');
        }
    }

    /**
     * Split model with a serial shorter than 10 chars: 2 Surgery records
     * should be created with null serial numbers (graceful degradation).
     */
    @Is{!Environment.IvanTest}
    static void testSplitModelWithShortSerialCreatesRecordsWithNullSerial() {
        Order ord = create{!Environment.IvanTest}Order();
        createOrderItem(ord.Id, NMD_OrderSubmissionManager.SPLIT_MODEL_NUMBER, '123');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(ord.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [
            SELECT Serial_Number__c
            FROM   Surgery__c
            WHERE  Order__c = :ord.Id
        ];
        System.assertEquals(2, surgeries.size(),
            '2 Surgery records should be created even when serial is too short.');
        for (Surgery__c s : surgeries) {
            System.assertEquals(null, s.Serial_Number__c,
                'Serial number should be null when source serial is too short to split.');
        }
    }

    /**
     * Bulk test: 50 split-model Order Items should produce 100 Surgery records.
     */
    @Is{!Environment.IvanTest}
    static void testBulkSplitModelSurgeryCreation() {
        Order ord = create{!Environment.IvanTest}Order();

        // Build products, pricebook entries, and order items in bulk
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 50; i++) {
            products.add(new Product2(
                Name        = 'SCS Bulk Product ' + i,
                ProductCode = NMD_OrderSubmissionManager.SPLIT_MODEL_NUMBER,
                IsActive    = true
            ));
        }
        insert products;

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 p : products) {
            pbes.add(new PricebookEntry(
                Pricebook2Id = {!Environment.IvanTest}.getStandardPricebookId(),
                Product2Id   = p.Id,
                UnitPrice    = 100.00,
                IsActive     = true
            ));
        }
        insert pbes;

        List<OrderItem> items = new List<OrderItem>();
        for (Integer i = 0; i < 50; i++) {
            items.add(new OrderItem(
                OrderId          = ord.Id,
                PricebookEntryId = pbes[i].Id,
                Quantity         = 1,
                UnitPrice        = 100.00,
                Serial_Number__c = '1234567890'
            ));
        }
        insert items;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        NMD_OrderSubmissionManager.createSurgeryForRelatedOrder(ord.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Surgery__c> surgeries = [
            SELECT Id FROM Surgery__c WHERE Order__c = :ord.Id
        ];
        System.assertEquals(100, surgeries.size(),
            '50 split-model items should produce 100 Surgery records.');
    }
}