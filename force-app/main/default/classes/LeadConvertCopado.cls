public class LeadConvertCopado {
    public static Map<String, Object> findAndConvertLead() {
        Map<String, Object> result = new Map<String, Object>();
        
        List<Lead> leads = [
            SELECT Id, Name, FirstName, LastName, Company, Email, Phone, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = 'Copado {!Environment.IvanTest} Lead'
            LIMIT 1
        ];
        
        if (leads.isEmpty()) {
            result.put('lead_id', '');
            result.put('lead_name', 'Copado {!Environment.IvanTest} Lead');
            result.put('conversion_status', 'error');
            result.put('message', 'No Lead found with name "Copado {!Environment.IvanTest} Lead".');
            System.debug('CONVERSION_RESULT: ' + JSON.serialize(result));
            return result;
        }
        
        Lead lead = leads[0];
        result.put('lead_id', lead.Id);
        result.put('lead_name', lead.Name);
        
        if (lead.IsConverted) {
            result.put('conversion_status', 'error');
            result.put('opportunity_id', lead.ConvertedOpportunityId);
            result.put('account_id', lead.ConvertedAccountId);
            result.put('message', 'Lead is already converted. ConvertedAccountId: ' + lead.ConvertedAccountId + ', ConvertedOpportunityId: ' + lead.ConvertedOpportunityId);
            System.debug('CONVERSION_RESULT: ' + JSON.serialize(result));
            return result;
        }
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setDoNotCreateOpportunity(false);
        
        String oppName = (String.isNotBlank(lead.Company) ? lead.Company : lead.Name) + ' - Opportunity';
        lc.setOpportunityName(oppName);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        if (lcr.isSuccess()) {
            String accountName = '';
            if (lcr.getAccountId() != null) {
                List<Account> accs = [SELECT Name FROM Account WHERE Id = :lcr.getAccountId() LIMIT 1];
                if (!accs.isEmpty()) accountName = accs[0].Name;
            }
            result.put('opportunity_id', lcr.getOpportunityId());
            result.put('opportunity_name', oppName);
            result.put('account_id', lcr.getAccountId());
            result.put('account_name', accountName);
            result.put('conversion_status', 'success');
            result.put('message', 'Lead successfully converted. Account, Contact, and Opportunity created.');
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getMessage() + '; ';
            }
            result.put('conversion_status', 'error');
            result.put('message', 'Lead conversion failed: ' + errors);
        }
        
        System.debug('CONVERSION_RESULT: ' + JSON.serialize(result));
        return result;
    }
}