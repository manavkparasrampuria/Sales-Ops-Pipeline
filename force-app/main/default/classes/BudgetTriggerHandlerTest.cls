@Is{!Environment.IvanTest}
private class BudgetTriggerHandler{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void makeData() {
        HomeBudget__c budget = new HomeBudget__c(
            Name   = '{!Environment.IvanTest} Budget',
            Status__c = 'Active'
        );
        insert budget;
    }

    // -------------------------------------------------------
    // Helper
    // -------------------------------------------------------
    private static HomeBudget__c getBudget() {
        return [SELECT Id, Total_Income__c, Total_Expenses__c FROM HomeBudget__c LIMIT 1];
    }

    // -------------------------------------------------------
    // 1. Insert income item -> Total_Income__c updated
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testInsertIncomeItem() {
        HomeBudget__c hb = getBudget();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c = hb.Id,
            Amount__c     = 1000,
            Type__c       = 'Income',
            Category__c   = 'Savings'
        );
        insert item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        HomeBudget__c result = getBudget();
        System.assertEquals(1000, result.Total_Income__c,   'Total Income should be 1000');
        System.assertEquals(0,    result.Total_Expenses__c, 'Total Expenses should be 0');
    }

    // -------------------------------------------------------
    // 2. Insert expense item -> Total_Expenses__c updated
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testInsertExpenseItem() {
        HomeBudget__c hb = getBudget();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c = hb.Id,
            Amount__c     = 500,
            Type__c       = 'Expense',
            Category__c   = 'Food'
        );
        insert item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        HomeBudget__c result = getBudget();
        System.assertEquals(500, result.Total_Expenses__c, 'Total Expenses should be 500');
        System.assertEquals(0,   result.Total_Income__c,   'Total Income should be 0');
    }

    // -------------------------------------------------------
    // 3. Update item amount -> totals recalculated
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testUpdateItemAmount() {
        HomeBudget__c hb = getBudget();
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c = hb.Id,
            Amount__c     = 200,
            Type__c       = 'Expense',
            Category__c   = 'Food'
        );
        insert item;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        item.Amount__c = 350;
        update item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        HomeBudget__c result = getBudget();
        System.assertEquals(350, result.Total_Expenses__c, 'Total Expenses should be updated to 350');
    }

    // -------------------------------------------------------
    // 4. Delete item -> totals recalculated
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testDeleteItem() {
        HomeBudget__c hb = getBudget();
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c = hb.Id,
            Amount__c     = 750,
            Type__c       = 'Income',
            Category__c   = 'Savings'
        );
        insert item;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        delete item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        HomeBudget__c result = getBudget();
        System.assertEquals(0, result.Total_Income__c, 'Total Income should be 0 after delete');
    }

    // -------------------------------------------------------
    // 5. Validation: Amount <= 0 should throw error
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testValidationAmountZero() {
        HomeBudget__c hb = getBudget();
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c = hb.Id,
            Amount__c     = 0,
            Type__c       = 'Expense',
            Category__c   = 'Food'
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert item;
            System.assert(false, 'Expected DmlException was not thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Amount must be greater than zero'),
                          'Expected validation error message');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    // -------------------------------------------------------
    // 6. Default description auto-populated when blank
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testDefaultDescription() {
        HomeBudget__c hb = getBudget();
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c = hb.Id,
            Amount__c     = 100,
            Type__c       = 'Expense',
            Category__c   = 'Food'
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        BudgetItem__c result = [SELECT Description__c FROM BudgetItem__c WHERE Id = :item.Id];
        System.assertEquals('Expense - Food', result.Description__c, 'Default description should be set');
    }

    // -------------------------------------------------------
    // 7. Multiple items across income and expense
    // -------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testMultipleItems() {
        HomeBudget__c hb = getBudget();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<BudgetItem__c> items = new List<BudgetItem__c>{
            new BudgetItem__c(HomeBudget__c = hb.Id, Amount__c = 3000, Type__c = 'Income',  Category__c = 'Savings'),
            new BudgetItem__c(HomeBudget__c = hb.Id, Amount__c = 800,  Type__c = 'Expense', Category__c = 'Housing'),
            new BudgetItem__c(HomeBudget__c = hb.Id, Amount__c = 200,  Type__c = 'Expense', Category__c = 'Food')
        };
        insert items;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        HomeBudget__c result = getBudget();
        System.assertEquals(3000, result.Total_Income__c,   'Total Income should be 3000');
        System.assertEquals(1000, result.Total_Expenses__c, 'Total Expenses should be 1000');
    }
}