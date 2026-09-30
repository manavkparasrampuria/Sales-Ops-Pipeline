public with sharing class AccountContactDashboardController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccountContacts(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('Account ID is required.');
        }
        return [
            SELECT Id, Name, Title, Email, Phone
            FROM Contact
            WHERE AccountId = :accountId
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT 200
        ];
    }
}