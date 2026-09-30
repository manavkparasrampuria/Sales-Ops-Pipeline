public class Convert{!Environment.IvanTest}Lead1908669 {
    public static Map<String, Object> run() {
        Map<String, Object> result = new Map<String, Object>();
        String leadName = '{!Environment.IvanTest}_Lead_1908669';

        List<Lead> leads = [
            SELECT Id, Name, FirstName, LastName, Company, Email, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = :leadName
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            result.put('status', 'error');
            result.put('message', 'No Lead found with name: ' + leadName);
            System.debug('LEAD_CONVERT_RESULT: ' + JSON.serialize(result));
            return result;
        }

        Lead lead = leads[0];
        result.put('lead_id', lead.Id);
        result.put('lead_name', lead.Name);

        if (lead.IsConverted) {
            result.put('status', 'already_converted');
            result.put('converted_account_id', lead.ConvertedAccountId);
            result.put('converted_contact_id', lead.ConvertedContactId);
            result.put('converted_opportunity_id', lead.ConvertedOpportunityId);
            result.put('message', 'Lead is already converted.');
            System.debug('LEAD_CONVERT_RESULT: ' + JSON.serialize(result));
            return result;
        }

        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(false);

        if ({!Environment.IvanTest}.isRunning{!Environment.IvanTest}()) {
            List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :lead.Company LIMIT 1];
            if (!existingAccounts.isEmpty()) {
                lc.setAccountId(existingAccounts[0].Id);
            }
        }

        String oppName = (String.isNotBlank(lead.Company) ? lead.Company : lead.Name) + ' - Opportunity';
        lc.setOpportunityName(oppName);

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            String accountName = '';
            String contactName = '';
            if (lcr.getAccountId() != null) {
                List<Account> accs = [SELECT Name FROM Account WHERE Id = :lcr.getAccountId() LIMIT 1];
                if (!accs.isEmpty()) accountName = accs[0].Name;
            }
            if (lcr.getContactId() != null) {
                List<Contact> cons = [SELECT Name FROM Contact WHERE Id = :lcr.getContactId() LIMIT 1];
                if (!cons.isEmpty()) contactName = cons[0].Name;
            }
            result.put('status', 'success');
            result.put('account_id', lcr.getAccountId());
            result.put('account_name', accountName);
            result.put('contact_id', lcr.getContactId());
            result.put('contact_name', contactName);
            result.put('opportunity_id', lcr.getOpportunityId());
            result.put('opportunity_name', oppName);
            result.put('message', 'Lead successfully converted.');
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getMessage() + '; ';
            }
            result.put('status', 'error');
            result.put('message', 'Conversion failed: ' + errors);
        }

        System.debug('LEAD_CONVERT_RESULT: ' + JSON.serialize(result));
        return result;
    }
}