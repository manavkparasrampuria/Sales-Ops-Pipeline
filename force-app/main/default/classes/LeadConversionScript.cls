public class LeadConversionScript {
    public static void run() {
        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Name, Email, Company, Status, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = '{!Environment.IvanTest}_Lead_1910334'
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            System.debug('LEAD_RESULT: NOT_FOUND');
            return;
        }

        Lead l = leads[0];
        System.debug('LEAD_RESULT: Id=' + l.Id + ' | Name=' + l.Name + ' | IsConverted=' + l.IsConverted + ' | Company=' + l.Company);

        if (l.IsConverted) {
            System.debug('LEAD_RESULT: ALREADY_CONVERTED | AccountId=' + l.ConvertedAccountId + ' | ContactId=' + l.ConvertedContactId + ' | OpportunityId=' + l.ConvertedOpportunityId);
            return;
        }

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setConvertedStatus('Qualified');
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(l.Name + ' - Opportunity');

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            System.debug('CONVERSION_SUCCESS: AccountId=' + lcr.getAccountId() + ' | ContactId=' + lcr.getContactId() + ' | OpportunityId=' + lcr.getOpportunityId());
        } else {
            for (Database.Error err : lcr.getErrors()) {
                System.debug('CONVERSION_ERROR: ' + err.getMessage());
            }
        }
    }
}