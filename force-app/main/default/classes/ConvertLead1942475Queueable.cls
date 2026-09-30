public class ConvertLead1942475Queueable implements Queueable {
    public void execute(QueueableContext ctx) {
        List<Lead> leads = [
            SELECT Id, Name, FirstName, LastName, Company, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name LIKE '%{!Environment.IvanTest}_Lead_1942475%'
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            System.debug('CONV_RESULT_1942475: STATUS=NOT_FOUND');
            return;
        }

        Lead l = leads[0];
        System.debug('CONV_RESULT_1942475: LEAD_ID=' + l.Id + ' | LEAD_NAME=' + l.Name + ' | IS_CONVERTED=' + l.IsConverted);

        if (l.IsConverted) {
            String accName = '';
            String conName = '';
            String oppName = '';
            if (l.ConvertedAccountId != null) {
                List<Account> accs = [SELECT Name FROM Account WHERE Id = :l.ConvertedAccountId LIMIT 1];
                if (!accs.isEmpty()) accName = accs[0].Name;
            }
            if (l.ConvertedContactId != null) {
                List<Contact> cons = [SELECT Name FROM Contact WHERE Id = :l.ConvertedContactId LIMIT 1];
                if (!cons.isEmpty()) conName = cons[0].Name;
            }
            if (l.ConvertedOpportunityId != null) {
                List<Opportunity> opps = [SELECT Name FROM Opportunity WHERE Id = :l.ConvertedOpportunityId LIMIT 1];
                if (!opps.isEmpty()) oppName = opps[0].Name;
            }
            System.debug('CONV_RESULT_1942475: STATUS=ALREADY_CONVERTED | ACCOUNT_ID=' + l.ConvertedAccountId + ' | ACCOUNT_NAME=' + accName + ' | CONTACT_ID=' + l.ConvertedContactId + ' | CONTACT_NAME=' + conName + ' | OPP_ID=' + l.ConvertedOpportunityId + ' | OPP_NAME=' + oppName);
            return;
        }

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(l.Name + ' - Opportunity');

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            String accName = '';
            String conName = '';
            if (lcr.getAccountId() != null) {
                List<Account> accs = [SELECT Name FROM Account WHERE Id = :lcr.getAccountId() LIMIT 1];
                if (!accs.isEmpty()) accName = accs[0].Name;
            }
            if (lcr.getContactId() != null) {
                List<Contact> cons = [SELECT Name FROM Contact WHERE Id = :lcr.getContactId() LIMIT 1];
                if (!cons.isEmpty()) conName = cons[0].Name;
            }
            System.debug('CONV_RESULT_1942475: STATUS=SUCCESS | LEAD_ID=' + lcr.getLeadId() + ' | ACCOUNT_ID=' + lcr.getAccountId() + ' | ACCOUNT_NAME=' + accName + ' | CONTACT_ID=' + lcr.getContactId() + ' | CONTACT_NAME=' + conName + ' | OPP_ID=' + lcr.getOpportunityId() + ' | OPP_NAME=' + l.Name + ' - Opportunity');
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getMessage() + '; ';
            }
            System.debug('CONV_RESULT_1942475: STATUS=ERROR | ERRORS=' + errors);
        }
    }
}