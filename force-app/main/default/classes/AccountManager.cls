public with sharing class AccountManager {
    
    // Method 1: Create Account
    public static Account createAccount(String name, String industry) {
        Account acc = new Account(
            Name = name,
            Industry = industry,
            Rating = 'Hot12345545234234frewrewr23'
        );
        insert acc;
        return acc;
    }
    
    // Method 2: Update Account Revenue
    public static void updateAccountRevenue(Id accountId, Decimal revenue) {
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];
        acc.AnnualRevenue = revenue;
        update acc;
    }
    
    // Method 3: Delete Old Accounts
    public static void deleteOldAccounts(Integer daysOld) {
        Date cutoffDate = Date.today().addDays(-daysOld);
        List<Account> oldAccounts = [
            SELECT Id 
            FROM Account 
            WHERE CreatedDate < :cutoffDate
        ];
        delete oldAccounts;
    }
    
    // Method 4: Get Account Count by Industry
    public static Map<String, Integer> getAccountCountByIndustry() {
        Map<String, Integer> industryMap = new Map<String, Integer>();
        
        for(AggregateResult ar : [
            SELECT Industry, COUNT(Id) cnt 
            FROM Account 
            WHERE Industry != null 
            GROUP BY Industry
        ]) {
            String industry = (String)ar.get('Industry');
            Integer count = (Integer)ar.get('cnt');
            industryMap.put(industry, count);
        }
        
        return industryMap;
    }
    
    // Method 5: Calculate Total Revenue
    public static Decimal calculateTotalRevenue(List<Id> accountIds) {
        Decimal totalRevenue = 0;
        
        for(Account acc : [
            SELECT AnnualRevenue 
            FROM Account 
            WHERE Id IN :accountIds
        ]) {
            if(acc.AnnualRevenue != null) {
                totalRevenue += acc.AnnualRevenue;
            }
        }
        
        return totalRevenue;
    }
    
    // Method 6: Mark Accounts as High Priority
    public static void markHighPriorityAccounts(Decimal revenueThreshold) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Account acc : [
            SELECT Id, AnnualRevenue 
            FROM Account 
            WHERE AnnualRevenue >= :revenueThreshold
        ]) {
            acc.Rating = 'Hot';
            acc.Description = 'High Priority Account';
            accountsToUpdate.add(acc);
        }
        
        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    // Method 7: Clone Account
    public static Account cloneAccount(Id accountId) {
        Account originalAcc = [
            SELECT Name, Industry, AnnualRevenue, Rating, Phone, Website 
            FROM Account 
            WHERE Id = :accountId 
            LIMIT 1
        ];
        
        Account clonedAcc = new Account(
            Name = originalAcc.Name + ' - Copy',
            Industry = originalAcc.Industry,
            AnnualRevenue = originalAcc.AnnualRevenue,
            Rating = originalAcc.Rating,
            Phone = originalAcc.Phone,
            Website = originalAcc.Website
        );
        
        insert clonedAcc;
        return clonedAcc;
    }
    
    // Method 8: Validate Account Data
    public static Boolean validateAccountData(Account acc) {
        if(String.isBlank(acc.Name)) {
            return false;
        }
        if(acc.Name.length() < 3) {
            return false;
        }
        if(acc.AnnualRevenue != null && acc.AnnualRevenue < 0) {
            return false;
        }
        return true;
    }
    
    // Method 9: Merge Duplicate Accounts
    public static void mergeDuplicateAccounts(Id masterAccountId, List<Id> duplicateIds) {
        Account masterAccount = [SELECT Id FROM Account WHERE Id = :masterAccountId LIMIT 1];
        List<Account> duplicates = [SELECT Id FROM Account WHERE Id IN :duplicateIds];
        
        Database.merge(masterAccount, duplicates, false);
    }
    
    // Method 10: Generate Account Report
    public static String generateAccountReport() {
        Integer totalAccounts = [SELECT COUNT() FROM Account];
        Decimal avgRevenue = 0;
        
        AggregateResult ar = [
            SELECT AVG(AnnualRevenue) avgRev 
            FROM Account 
            WHERE AnnualRevenue != null
        ];
        
        if(ar.get('avgRev') != null) {
            avgRevenue = (Decimal)ar.get('avgRev');
        }
        
        return 'Total Accounts: ' + totalAccounts + ', Average Revenue: ' + avgRevenue;
    }
}