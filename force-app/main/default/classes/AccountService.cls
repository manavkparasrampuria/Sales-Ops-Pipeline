// Apex Class
public with sharing class AccountService {

    public static String getAccountType(Account acc) {
        if (acc.Type == 'Customer') {
            return 'This is a Customer account';
        } else if (acc.Type == 'Partner') {
            return 'This is a Partner account';
        } else if (acc.Type == 'Competitor') {
            return 'This is a Competitor account';
        } else {
            return 'Unknown account type';
        }
    }

    public static Decimal calculateDiscount(Decimal amount, String tier) {
        if (tier == 'Gold') {
            return amount * 0.20;
        } else if (tier == 'Silver') {
            return amount * 0.10;
        } else {
            return 0;
        }
    }
}