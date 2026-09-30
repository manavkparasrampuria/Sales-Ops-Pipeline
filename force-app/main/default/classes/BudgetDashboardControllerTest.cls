@Is{!Environment.IvanTest}
private class BudgetDashboardController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void makeData() {
        HomeBudget__c budget = new HomeBudget__c(
            Name      = '{!Environment.IvanTest} Budget',
            Status__c = 'Active'
        );
        insert budget;

        List<BudgetItem__c> items = new List<BudgetItem__c>{
            new BudgetItem__c(HomeBudget__c = budget.Id, Type__c = 'Income',  Amount__c = 2000, Category__c = 'Savings'),
            new BudgetItem__c(HomeBudget__c = budget.Id, Type__c = 'Expense', Amount__c = 500,  Category__c = 'Food')
        };
        insert items;
    }

    static HomeBudget__c getBudget() {
        return [SELECT Id FROM HomeBudget__c LIMIT 1];
    }

    @Is{!Environment.IvanTest}
    static void testGetBudgetDetails() {
        HomeBudget__c hb = getBudget();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        HomeBudget__c result = BudgetDashboardController.getBudgetDetails(hb.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Budget should be returned');
        System.assertEquals('{!Environment.IvanTest} Budget', result.Name, 'Budget name should match');
    }

    @Is{!Environment.IvanTest}
    static void testGetBudgetItemsAll() {
        HomeBudget__c hb = getBudget();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<BudgetItem__c> items = BudgetDashboardController.getBudgetItems(hb.Id, 'All');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(2, items.size(), 'Should return 2 items');
    }

    @Is{!Environment.IvanTest}
    static void testGetBudgetItemsFilteredIncome() {
        HomeBudget__c hb = getBudget();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<BudgetItem__c> items = BudgetDashboardController.getBudgetItems(hb.Id, 'Income');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(1, items.size(), 'Should return 1 income item');
        System.assertEquals('Income', items[0].Type__c, 'Type should be Income');
    }

    @Is{!Environment.IvanTest}
    static void testGetBudgetItemsFilteredExpense() {
        HomeBudget__c hb = getBudget();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<BudgetItem__c> items = BudgetDashboardController.getBudgetItems(hb.Id, 'Expense');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(1, items.size(), 'Should return 1 expense item');
        System.assertEquals('Expense', items[0].Type__c, 'Type should be Expense');
    }

    @Is{!Environment.IvanTest}
    static void testSaveBudgetItem() {
        HomeBudget__c hb = getBudget();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        BudgetDashboardController.saveBudgetItem(hb.Id, 'Expense', 'Housing', 1200, 'Rent');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<BudgetItem__c> items = [SELECT Id FROM BudgetItem__c WHERE HomeBudget__c = :hb.Id];
        System.assertEquals(3, items.size(), 'Should now have 3 items');
    }

    @Is{!Environment.IvanTest}
    static void testDeleteBudgetItem() {
        HomeBudget__c hb = getBudget();
        BudgetItem__c item = [SELECT Id FROM BudgetItem__c WHERE HomeBudget__c = :hb.Id LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        BudgetDashboardController.deleteBudgetItem(item.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<BudgetItem__c> remaining = [SELECT Id FROM BudgetItem__c WHERE HomeBudget__c = :hb.Id];
        System.assertEquals(1, remaining.size(), 'Should have 1 item remaining after delete');
    }
}