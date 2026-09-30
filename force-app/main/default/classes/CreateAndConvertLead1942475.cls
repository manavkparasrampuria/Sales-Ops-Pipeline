@is{!Environment.IvanTest}(SeeAllData=true)
public class CreateAndConvertLead1942475 {
    @is{!Environment.IvanTest}
    static void createAndConvert() {
        // Check if Lead already exists
        List<Lead> existing = [
            SELECT Id, Name, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name LIKE '%{!Environment.IvanTest}_Lead_1942475%'
            LIMIT 1
        ];

        Lead lead;
        Boolean wasCreated = false;

        if (existing.isEmpty()) {
            // Create the Lead
            lead = new Lead(
                FirstName  = '{!Environment.IvanTest}_Lead',
                LastName   = '1942475',
                Company    = '{!Environment.IvanTest} Company 1942475',
                Email      = 'test_lead_1942475@example.com',
                Phone      = '5551942475',
                Status     = 'Open - Not Contacted'
            );
            insert lead;
            wasCreated = true;
            System.debug('LEAD_1942475: CREATED | Id=' + lead.Id + ' | Name=' + lead.FirstName + ' ' + lead.LastName);
        } else {
            lead = existing[0];
            System.debug('LEAD_1942475: FOUND | Id=' + lead.Id + ' | Name=' + lead.Name + ' | IsConverted=' + lead.IsConverted);
        }

        // Re-query to get full details
        lead = [
            SELECT Id, Name, FirstName, LastName, Company, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead WHERE Id = :lead.Id LIMIT 1
        ];

        if (lead.IsConverted) {
            String accName = '';
            String conName = '';
            String oppName = '';
            if (lead.ConvertedAccountId != null) {
                List<Account> accs = [SELECT Name FROM Account WHERE Id = :lead.ConvertedAccountId LIMIT 1];
                if (!accs.isEmpty()) accName = accs[0].Name;
            }
            if (lead.ConvertedContactId != null) {
                List<Contact> cons = [SELECT Name FROM Contact WHERE Id = :lead.ConvertedContactId LIMIT 1];
                if (!cons.isEmpty()) conName = cons[0].Name;
            }
            if (lead.ConvertedOpportunityId != null) {
                List<Opportunity> opps = [SELECT Name FROM Opportunity WHERE Id = :lead.ConvertedOpportunityId LIMIT 1];
                if (!opps.isEmpty()) oppName = opps[0].Name;
            }
            System.debug('CONV_RESULT_1942475: STATUS=ALREADY_CONVERTED | LEAD_ID=' + lead.Id + ' | LEAD_NAME=' + lead.Name + ' | ACCOUNT_ID=' + lead.ConvertedAccountId + ' | ACCOUNT_NAME=' + accName + ' | CONTACT_ID=' + lead.ConvertedContactId + ' | CONTACT_NAME=' + conName + ' | OPP_ID=' + lead.ConvertedOpportunityId + ' | OPP_NAME=' + oppName);
            return;
        }

        // Convert the Lead
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        String oppName = lead.Name + ' - Opportunity';

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(oppName);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

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
            System.debug('CONV_RESULT_1942475: STATUS=SUCCESS | LEAD_CREATED=' + wasCreated + ' | LEAD_ID=' + lcr.getLeadId() + ' | LEAD_NAME=' + lead.Name + ' | ACCOUNT_ID=' + lcr.getAccountId() + ' | ACCOUNT_NAME=' + accName + ' | CONTACT_ID=' + lcr.getContactId() + ' | CONTACT_NAME=' + conName + ' | OPP_ID=' + lcr.getOpportunityId() + ' | OPP_NAME=' + oppName);
            System.assert(lcr.isSuccess(), 'Lead conversion should succeed');
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getMessage() + '; ';
            }
            System.debug('CONV_RESULT_1942475: STATUS=ERROR | ERRORS=' + errors);
            System.assert(false, 'Lead conversion failed: ' + errors);
        }
    }
}