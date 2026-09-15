public with sharing class AccountContactDashboardController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccountContacts(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('Account ID is required.');
        }
        
    }
}