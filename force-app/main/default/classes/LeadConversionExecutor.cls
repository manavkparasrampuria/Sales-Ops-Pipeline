public class LeadConversionExecutor {

    public static Map<String, String> execute(String leadName) {
        Map<String, String> result = new Map<String, String>();

        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Name, Email, Company, Phone, Status,
                   IsConverted, ConvertedAccountId, ConvertedContactId,
                   ConvertedOpportunityId, ConvertedDate
            FROM Lead
            WHERE Name = :leadName
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            result.put('status', 'NOT_FOUND');
            result.put('message', 'Lead not found: ' + leadName);
            return result;
        }

        Lead lead = leads[0];
        result.put('leadId', lead.Id);
        result.put('leadName', lead.Name);
        result.put('leadCompany', lead.Company);
        result.put('leadStatus', lead.Status);
        result.put('isConverted', String.valueOf(lead.IsConverted));

        if (lead.IsConverted) {
            result.put('status', 'ALREADY_CONVERTED');
            result.put('message', 'Lead was already converted on ' + lead.ConvertedDate);
            result.put('convertedAccountId', lead.ConvertedAccountId);
            result.put('convertedContactId', lead.ConvertedContactId);
            result.put('convertedOpportunityId', lead.ConvertedOpportunityId);

            if (lead.ConvertedAccountId != null) {
                Account acc = [SELECT Name FROM Account WHERE Id = :lead.ConvertedAccountId LIMIT 1];
                result.put('accountName', acc.Name);
            }
            if (lead.ConvertedContactId != null) {
                Contact con = [SELECT Name FROM Contact WHERE Id = :lead.ConvertedContactId LIMIT 1];
                result.put('contactName', con.Name);
            }
            if (lead.ConvertedOpportunityId != null) {
                Opportunity opp = [SELECT Name FROM Opportunity WHERE Id = :lead.ConvertedOpportunityId LIMIT 1];
                result.put('opportunityName', opp.Name);
            }
            return result;
        }

        List<LeadStatus> convertedStatuses = [
            SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1
        ];
        String convertedStatus = convertedStatuses.isEmpty()
            ? 'Closed - Converted'
            : convertedStatuses[0].MasterLabel;

        String oppName = (lead.Company != null ? lead.Company : lead.Name) + ' - ' + lead.Name;
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(convertedStatus);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(oppName);

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            result.put('status', 'CONVERTED');
            result.put('message', 'Lead converted successfully.');
            result.put('accountId', lcr.getAccountId());
            result.put('contactId', lcr.getContactId());
            result.put('opportunityId', lcr.getOpportunityId());

            if (lcr.getAccountId() != null) {
                Account acc = [SELECT Name FROM Account WHERE Id = :lcr.getAccountId() LIMIT 1];
                result.put('accountName', acc.Name);
            }
            if (lcr.getContactId() != null) {
                Contact con = [SELECT Name FROM Contact WHERE Id = :lcr.getContactId() LIMIT 1];
                result.put('contactName', con.Name);
            }
            if (lcr.getOpportunityId() != null) {
                Opportunity opp = [SELECT Name FROM Opportunity WHERE Id = :lcr.getOpportunityId() LIMIT 1];
                result.put('opportunityName', opp.Name);
            }
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getMessage() + '; ';
            }
            result.put('status', 'ERROR');
            result.put('message', 'Conversion failed: ' + errors);
        }

        return result;
    }
}