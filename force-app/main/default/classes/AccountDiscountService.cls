public with sharing class AccountDiscountService {

    // Covered by the test (a few lines only)
    public static Decimal calculateDiscount(Decimal amount) {
        if (amount == null) {
            return 0;
        }
        return amount * 0.10;
    }

    // NOT covered by the test
    public static String getTier(Decimal annualRevenue) {
        if (annualRevenue == null) {
            return 'None';
        }
        if (annualRevenue >= 1000000) {
            return 'Platinum';
        } else if (annualRevenue >= 500000) {
            return 'Gold';
        } else if (annualRevenue >= 100000) {
            return 'Silver';
        }
        return 'Bronze';
    }

    // NOT covered by the test
    public static Integer countAccountsByTier(String tier) {
        Integer total = 0;
        for (Account acc : [
            SELECT Id, AnnualRevenue
            FROM Account
            WITH USER_MODE
            LIMIT 200
        ]) {
            if (getTier(acc.AnnualRevenue) == tier) {
                total++;
            }
        }
        return total;
    }

    // NOT covered by the test
    public static void applyDiscountToOpportunities(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        List<Opportunity> opps = [
            SELECT Id, Amount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND Amount != null
            WITH USER_MODE
        ];
        for (Opportunity opp : opps) {
            opp.Amount = opp.Amount - calculateDiscount(opp.Amount);
        }
        update as user opps;
    }
}