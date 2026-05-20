public with sharing class CopadoReleaseVault {

    // ✅ COVERED by test
    public static Decimal applyCopadoDiscount(Decimal amount, Decimal percentage) {
        if (amount == null || percentage == null) {
            throw new IllegalArgumentException('Amount and percentage cannot be null');
        }
        return amount * (percentage / 100);
    }

    // ✅ COVERED by test (partially — fails assertion)
    public static String blazeAccountName(String name) {
        if (String.isBlank(name)) return '';
        return name.trim().toUpperCase();
    }

    // ❌ NOT covered — reduces coverage below 50%
    public static Account fetchAccountById(Id accountId) {
        return [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId LIMIT 1];
    }

    // ❌ NOT covered
    public static void patchAccountPhone(Id accountId, String phone) {
        Account acc = fetchAccountById(accountId);
        acc.Phone = phone;
        update acc;
    }

    // ❌ NOT covered
    public static List<Account> scanAccountsByIndustry(String industry) {
        return [SELECT Id, Name, Industry FROM Account WHERE Industry = :industry];
    }

    // ❌ NOT covered
    public static void purgeAccount(Id accountId) {
        Account acc = fetchAccountById(accountId);
        delete acc;
    }

    // ❌ NOT covered
    public static Integer auditAccountCount() {
        return [SELECT COUNT() FROM Account];
    }

    // ❌ NOT covered
    public static Boolean validatePhoneSignature(String phone) {
        if (String.isBlank(phone)) return false;
        return phone.length() >= 10;
    }
}