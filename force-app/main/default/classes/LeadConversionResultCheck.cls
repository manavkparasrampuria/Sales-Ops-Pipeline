public class LeadConversionResultCheck {
    public static void run() {
        List<Lead> leads = [
            SELECT Id, Name, IsConverted, Status, Company,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = '{!Environment.IvanTest}_Lead_1910334'
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            System.debug('RESULT: LEAD_NOT_FOUND');
            return;
        }

        Lead l = leads[0];
        System.debug('LEAD_ID: ' + l.Id);
        System.debug('LEAD_NAME: ' + l.Name);
        System.debug('IS_CONVERTED: ' + l.IsConverted);

        if (!l.IsConverted) {
            System.debug('RESULT: NOT_YET_CONVERTED');
            return;
        }

        Account acc = [SELECT Id, Name FROM Account WHERE Id = :l.ConvertedAccountId];
        Contact con = [SELECT Id, Name FROM Contact WHERE Id = :l.ConvertedContactId];
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Id = :l.ConvertedOpportunityId];

        System.debug('ACCOUNT_ID: '   + acc.Id);
        System.debug('ACCOUNT_NAME: ' + acc.Name);
        System.debug('CONTACT_ID: '   + con.Id);
        System.debug('CONTACT_NAME: ' + con.Name);
        System.debug('OPP_ID: '       + opp.Id);
        System.debug('OPP_NAME: '     + opp.Name);
    }
}