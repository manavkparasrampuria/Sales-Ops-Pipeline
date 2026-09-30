public class ConvertLead1950325 {
    public class Result {
        public String leadId;
        public String leadName;
        public String leadCompany;
        public String leadStatus;
        public Boolean wasAlreadyConverted;
        public String accountId;
        public String contactId;
        public String opportunityId;
        public String message;
    }

    public static Result run() {
        Result res = new Result();

        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Name, Email, Company, Status,
                   IsConverted, ConvertedAccountId, ConvertedContactId,
                   ConvertedOpportunityId, ConvertedDate
            FROM Lead
            WHERE Name = '{!Environment.IvanTest}_Lead_1950325'
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            res.message = 'LEAD_NOT_FOUND: No Lead with name {!Environment.IvanTest}_Lead_1950325 exists.';
            return res;
        }

        Lead lead = leads[0];
        res.leadId      = lead.Id;
        res.leadName    = lead.Name;
        res.leadCompany = lead.Company;
        res.leadStatus  = lead.Status;
        res.wasAlreadyConverted = lead.IsConverted;

        if (lead.IsConverted) {
            res.accountId     = lead.ConvertedAccountId;
            res.contactId     = lead.ConvertedContactId;
            res.opportunityId = lead.ConvertedOpportunityId;
            res.message = 'ALREADY_CONVERTED: Lead was previously converted.';
            return res;
        }

        LeadStatus convertedStatus = [
            SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1
        ];

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(convertedStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(lead.Name + ' - Opportunity');

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            res.accountId     = lcr.getAccountId();
            res.contactId     = lcr.getContactId();
            res.opportunityId = lcr.getOpportunityId();
            res.message = 'SUCCESS: Lead converted successfully.';
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getStatusCode() + ': ' + err.getMessage() + '; ';
            }
            res.message = 'ERROR: ' + errors;
        }

        return res;
    }
}