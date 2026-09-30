public with sharing class CustomerAccountService {

    public static String getCustomerCategory(Id accountId) {
        Account acc = [
            SELECT Id, Name, Type, Industry
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        if (acc.Type == 'Customer') {
            return 'Customer Account';
        } else if (acc.Type == 'Partner') {
            return 'Partner Account';
        } else {
            return 'Other Account';
        }
    }

    public static String getIndustry(Id accountId) {
        Account acc = [
            SELECT Id, Name, Type, Industry
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        return acc.Industry;
    }

    /**
     * Sets a default Description on Accounts that do not already have one.
     * Invoked from CustomerAccountTrigger (before insert on Account).
     * Bulkified to safely process the full trigger context list.
     */
    public static void setDefaultDescription(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Description)) {
                if (acc.Type == 'Customer') {
                    acc.Description = 'Default description: Customer Account';
                } else if (acc.Type == 'Partner') {
                    acc.Description = 'Default description: Partner Account';
                } else {
                    acc.Description = 'Default description: Other Account';
                }
            }
        }
    }
}