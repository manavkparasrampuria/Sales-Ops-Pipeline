public class LeadConversionQueueable implements Queueable {
    public void execute(QueueableContext ctx) {
        List<Lead> leads = [
            SELECT Id, Name, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = '{!Environment.IvanTest}_Lead_1910334'
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            System.debug('QUEUEABLE_RESULT: LEAD_NOT_FOUND');
            return;
        }

        Lead l = leads[0];

        if (l.IsConverted) {
            System.debug('QUEUEABLE_RESULT: ALREADY_CONVERTED');
            System.debug('ACCOUNT_ID: ' + l.ConvertedAccountId);
            System.debug('CONTACT_ID: ' + l.ConvertedContactId);
            System.debug('OPP_ID: '     + l.ConvertedOpportunityId);
            return;
        }

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setConvertedStatus('Qualified');
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(l.Name + ' - Opportunity');

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            System.debug('QUEUEABLE_RESULT: CONVERSION_SUCCESS');
            System.debug('ACCOUNT_ID: ' + lcr.getAccountId());
            System.debug('CONTACT_ID: ' + lcr.getContactId());
            System.debug('OPP_ID: '     + lcr.getOpportunityId());
        } else {
            for (Database.Error err : lcr.getErrors()) {
                System.debug('QUEUEABLE_ERROR: ' + err.getMessage());
            }
        }
    }
}