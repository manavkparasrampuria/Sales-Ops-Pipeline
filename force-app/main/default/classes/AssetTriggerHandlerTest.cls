/**
 * @description Unit tests for AssetTriggerHandler and AssetService.
 *              Covers happy-path and negative scenarios for all validations
 *              and the trigger entry points.
 * @author      Copado Build Agent
 * @date        2026-08-14
 */
@Is{!Environment.IvanTest}
private class AssetTriggerHandler{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Setup ──────────────────────────────────────────────────────

    @{!Environment.IvanTest}Setup
    static void makeData() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account');
        insert acc;

        Product2 prod = new Product2(Name = '{!Environment.IvanTest} Product', IsActive = true);
        insert prod;
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private static Account getAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    private static Product2 getProduct() {
        return [SELECT Id FROM Product2 LIMIT 1];
    }

    private static Asset buildAsset(Id accountId) {
        return new Asset(
            Name        = '{!Environment.IvanTest} Asset',
            AccountId   = accountId,
            Status      = 'Purchased',
            Quantity    = 1,
            PurchaseDate = Date.today()
        );
    }

    // ─── Insert {!Environment.IvanTest}s ─────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testInsert_happyPath() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert a;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Asset inserted = [SELECT Id, Status FROM Asset WHERE Id = :a.Id];
        System.assertEquals('Purchased', inserted.Status, 'Status should be Purchased');
    }

    @Is{!Environment.IvanTest}
    static void testInsert_defaultStatus() {
        Account acc = getAccount();
        Asset a = new Asset(
            Name      = 'No Status Asset',
            AccountId = acc.Id,
            Quantity  = 1
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert a;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Asset inserted = [SELECT Status FROM Asset WHERE Id = :a.Id];
        System.assertEquals('Purchased', inserted.Status, 'Default status should be Purchased');
    }

    @Is{!Environment.IvanTest}
    static void testInsert_missingAccount_fails() {
        Asset a = new Asset(
            Name     = 'No Account Asset',
            Status   = 'Purchased',
            Quantity = 1
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert a;
            System.assert(false, 'Expected DmlException for missing AccountId');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Account'),
                'Error should mention Account: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testInsert_invalidStartStatus_fails() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        a.Status = 'Registered'; // Not a valid starting status

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert a;
            System.assert(false, 'Expected DmlException for invalid start status');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Purchased') || e.getMessage().contains('Shipped'),
                'Error should mention valid starting statuses: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testInsert_negativeQuantity_fails() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        a.Quantity = -5;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert a;
            System.assert(false, 'Expected DmlException for negative quantity');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Quantity'),
                'Error should mention Quantity: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testInsert_installBeforePurchase_fails() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        a.PurchaseDate = Date.today();
        a.InstallDate  = Date.today().addDays(-1); // Before purchase

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert a;
            System.assert(false, 'Expected DmlException for invalid dates');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Install Date'),
                'Error should mention Install Date: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    // ─── Update / Status Transition {!Environment.IvanTest}s ────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testUpdate_validTransition_PurchasedToShipped() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        insert a;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        a.Status = 'Shipped';
        update a;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Asset updated = [SELECT Status FROM Asset WHERE Id = :a.Id];
        System.assertEquals('Shipped', updated.Status, 'Status should be Shipped');
    }

    @Is{!Environment.IvanTest}
    static void testUpdate_validTransition_ShippedToInstalled() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        a.Status = 'Shipped';
        insert a;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        a.Status = 'Installed';
        update a;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Asset updated = [SELECT Status FROM Asset WHERE Id = :a.Id];
        System.assertEquals('Installed', updated.Status, 'Status should be Installed');
    }

    @Is{!Environment.IvanTest}
    static void testUpdate_invalidTransition_fails() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        insert a;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        a.Status = 'Installed'; // Purchased -> Installed is not allowed
        try {
            update a;
            System.assert(false, 'Expected DmlException for invalid transition');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Invalid status transition'),
                'Error should mention invalid transition: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testUpdate_sameStatus_noError() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        insert a;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        a.Status = 'Purchased'; // Same status, should not error
        a.Description = 'Updated description';
        update a;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Asset updated = [SELECT Status, Description FROM Asset WHERE Id = :a.Id];
        System.assertEquals('Purchased', updated.Status);
        System.assertEquals('Updated description', updated.Description);
    }

    @Is{!Environment.IvanTest}
    static void testUpdate_quantityZero_fails() {
        Account acc = getAccount();
        Asset a = buildAsset(acc.Id);
        insert a;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        a.Quantity = 0;
        try {
            update a;
            System.assert(false, 'Expected DmlException for zero quantity');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Quantity'),
                'Error should mention Quantity: ' + e.getMessage()
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    // ─── Bulk {!Environment.IvanTest}s ───────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testBulkInsert_200Records() {
        Account acc = getAccount();
        List<Asset> assets = new List<Asset>();
        for (Integer i = 0; i < 200; i++) {
            assets.add(new Asset(
                Name      = 'Bulk Asset ' + i,
                AccountId = acc.Id,
                Status    = 'Purchased',
                Quantity  = i + 1
            ));
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert assets;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Integer count = [SELECT COUNT() FROM Asset WHERE AccountId = :acc.Id];
        System.assertEquals(200, count, 'All 200 assets should be inserted');
    }

    @Is{!Environment.IvanTest}
    static void testBulkUpdate_statusTransition() {
        Account acc = getAccount();
        List<Asset> assets = new List<Asset>();
        for (Integer i = 0; i < 200; i++) {
            assets.add(new Asset(
                Name      = 'Bulk Asset ' + i,
                AccountId = acc.Id,
                Status    = 'Purchased',
                Quantity  = 1
            ));
        }
        insert assets;

        for (Asset a : assets) {
            a.Status = 'Shipped';
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update assets;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Asset> updated = [SELECT Status FROM Asset WHERE AccountId = :acc.Id];
        for (Asset a : updated) {
            System.assertEquals('Shipped', a.Status, 'All assets should be Shipped');
        }
    }
}