// ─────────────────────────────────────────
// Class 2: OpportunityHelper
// ─────────────────────────────────────────
public with sharing class OpportunityHelper {

    public static String getDealStage(Opportunity opp) {
        if (opp.Amount >= 500000) {
            return 'Enterprise Deal';
        } else if (opp.Amount >= 100000) {
            return 'Mid Market Deal';
        } else if (opp.Amount >= 10000) {
            return 'SMB Deal';
        } else {
            return 'Small Deal';
        }
    }

    public static Boolean isClosingSoon(Opportunity opp) {
        if (opp.CloseDate <= Date.today().addDays(7)) {
            return true;
        } else {
            return false;
        }
    }
}