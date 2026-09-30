public class QueryLead1908669 {
    public static void run() {
        List<Lead> leads = [
            SELECT Id, Name, FirstName, LastName, Company, Phone, Email,
                   IsConverted, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = '{!Environment.IvanTest}_Lead_1908669'
            LIMIT 1
        ];
        if (leads.isEmpty()) {
            System.debug('QUERY_RESULT=NOT_FOUND');
            return;
        }
        Lead l = leads[0];
        System.debug('QUERY_LEAD_ID=' + l.Id);
        System.debug('QUERY_LEAD_NAME=' + l.Name);
        System.debug('QUERY_LEAD_COMPANY=' + l.Company);
        System.debug('QUERY_LEAD_PHONE=' + l.Phone);
        System.debug('QUERY_LEAD_IS_CONVERTED=' + l.IsConverted);
        System.debug('QUERY_CONVERTED_ACCOUNT_ID=' + l.ConvertedAccountId);
        System.debug('QUERY_CONVERTED_CONTACT_ID=' + l.ConvertedContactId);
        System.debug('QUERY_CONVERTED_OPP_ID=' + l.ConvertedOpportunityId);

        if (l.IsConverted && l.ConvertedOpportunityId != null) {
            List<Opportunity> opps = [SELECT Id, Name FROM Opportunity WHERE Id = :l.ConvertedOpportunityId LIMIT 1];
            if (!opps.isEmpty()) System.debug('QUERY_OPP_NAME=' + opps[0].Name);
        }
        if (l.IsConverted && l.ConvertedAccountId != null) {
            List<Account> accs = [SELECT Id, Name FROM Account WHERE Id = :l.ConvertedAccountId LIMIT 1];
            if (!accs.isEmpty()) System.debug('QUERY_ACCOUNT_NAME=' + accs[0].Name);
        }
        if (l.IsConverted && l.ConvertedContactId != null) {
            List<Contact> cons = [SELECT Id, Name FROM Contact WHERE Id = :l.ConvertedContactId LIMIT 1];
            if (!cons.isEmpty()) System.debug('QUERY_CONTACT_NAME=' + cons[0].Name);
        }
    }
}