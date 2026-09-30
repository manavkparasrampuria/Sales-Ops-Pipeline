public with sharing class BudgetDashboardController {

    @AuraEnabled(cacheable=true)
    public static HomeBudget__c getBudgetDetails(Id budgetId) {
        return [
            SELECT Id, Name, Status__c, Budget_Period__c,
                   Total_Income__c, Total_Expenses__c, Notes__c
            FROM   HomeBudget__c
            WHERE  Id = :budgetId
            LIMIT  1
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<BudgetItem__c> getBudgetItems(Id budgetId, String filterType) {
        String query = 'SELECT Id, Name, Type__c, Category__c, Amount__c, Description__c ' +
                       'FROM BudgetItem__c WHERE HomeBudget__c = :budgetId';
        if (filterType != null && filterType != 'All') {
            query += ' AND Type__c = :filterType';
        }
        query += ' ORDER BY CreatedDate DESC';
        return Database.query(query);
    }

    @AuraEnabled
    public static void saveBudgetItem(Id budgetId, String itemType, String category,
                                      Decimal amount, String description) {
        BudgetItem__c item = new BudgetItem__c(
            HomeBudget__c  = budgetId,
            Type__c        = itemType,
            Category__c    = category,
            Amount__c      = amount,
            Description__c = description
        );
        insert item;
    }

    @AuraEnabled
    public static void deleteBudgetItem(Id itemId) {
        BudgetItem__c item = [SELECT Id FROM BudgetItem__c WHERE Id = :itemId LIMIT 1];
        delete item;
    }
}