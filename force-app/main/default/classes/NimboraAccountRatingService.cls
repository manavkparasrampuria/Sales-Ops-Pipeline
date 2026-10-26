/**
 * Updates the Rating on Accounts based on their annual revenue.
 * Bulkified, respects sharing, and enforces CRUD/FLS with user mode.
 */
public with sharing class NimboraAccountRatingService {

    private static final Decimal HOT_THRESHOLD = 1000000;
    private static final Decimal WARM_THRESHOLD = 100000;

    public static void updateRatings(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : [
            SELECT Id, AnnualRevenue, Rating
            FROM Account
            WHERE Id IN :accountIds
            WITH USER_MODE
        ]) {
            String newRating = calculateRating(acc.AnnualRevenue);
            if (acc.Rating != newRating) {
                acc.Rating = newRating;
                accountsToUpdate.add(acc);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            Database.update(accountsToUpdate, AccessLevel.USER_MODE);
        }
    }

    @TestVisible
    private static String calculateRating(Decimal annualRevenue) {
        if (annualRevenue == null) {
            return null;
        }
        if (annualRevenue >= HOT_THRESHOLD) {
            return 'Hot';
        }
        if (annualRevenue >= WARM_THRESHOLD) {
            return 'Warm';
        }
        return 'Cold';
    }
}