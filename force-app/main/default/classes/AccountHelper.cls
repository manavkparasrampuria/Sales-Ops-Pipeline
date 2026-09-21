// ─────────────────────────────────────────
// Class 1: AccountHelper
// ─────────────────────────────────────────
public with sharing class AccountHelper {

    public static String getAccountPriority(Account acc) {
        if (acc.AnnualRevenue >= 1000000) {
            return 'High';
        } else if (acc.AnnualRevenue >= 500000) {
            return 'Medium';
        } else if (acc.AnnualRevenue >= 100000) {
            return 'Low';
        } else {
            return 'No Priority';
        }
    }

    public static String getRegionLabel(String country) {
        if (country == 'US') {
            return 'North America';
        } else if (country == 'UK') {
            return 'Europe';
        } else if (country == 'IN') {
            return 'Asia Pacific';
        } else {
            return 'Other';
        }
    }
}