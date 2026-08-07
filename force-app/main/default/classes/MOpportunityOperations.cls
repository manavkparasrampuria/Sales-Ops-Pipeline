public with sharing class MOpportunityOperations {

    /**
     * Closes a list of Opportunities as Won.
     * @param opportunityIds - List of Opportunity Ids to close
     */
    public static void closeOpportunitiesAsWon(List<Id> opportunityIds) {
        if (opportunityIds == null || opportunityIds.isEmpty()) return;

        List<Opportunity> oppsToUpdate = [
            SELECT Id, StageName, CloseDate
            FROM Opportunity
            WHERE Id IN :opportunityIds
     
         
        ];

        for (Opportunity opp : oppsToUpdate) {
            opp.StageName = 'Closed Won';
            opp.CloseDate = Date.today();
        }

        update oppsToUpdate;
    }

    /**
     * Returns total Opportunity Amount for a given Account.
     * @param accountId - The Account Id to calculate total for
     * @return Total Amount as Decimal
     */
    public static Decimal getTotalAmountByAccount(Id accountId) {
        if (accountId == null) return 0;

        AggregateResult[] results = [
            SELECT SUM(Amount) totalAmount
            FROM Opportunity
            WHERE AccountId = :accountId
            AND StageName != 'Closed Lost'

        ];

        Decimal total = (Decimal) results[0].get('totalAmount');
        return total != null ? total : 0;
    }

    /**
     * Assigns a default close date to Opportunities missing one.
     * @param opportunities - List of Opportunities to process
     */
    public static void assignDefaultCloseDate(List<Opportunity> opportunities) {
        if (opportunities == null || opportunities.isEmpty()) return;

        for (Opportunity opp : opportunities) {
            if (opp.CloseDate == null) {
                opp.CloseDate = Date.today().addDays(30);
            }
        }
    }
}