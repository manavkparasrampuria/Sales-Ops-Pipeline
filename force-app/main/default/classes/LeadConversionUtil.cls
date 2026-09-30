public class LeadConversionUtil {

    public class ConversionResult {
        public String leadId;
        public String leadName;
        public Boolean isConverted;
        public String status;
        public String accountId;
        public String contactId;
        public String opportunityId;
        public String message;
    }

    public static ConversionResult convertLead(String leadName) {
        ConversionResult res = new ConversionResult();

        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Name, Email, Company, Phone, Status,
                   IsConverted, ConvertedAccountId, ConvertedContactId,
                   ConvertedOpportunityId, ConvertedDate
            FROM Lead
            WHERE Name = :leadName
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            res.message = 'Lead not found: ' + leadName;
            return res;
        }

        Lead lead = leads[0];
        res.leadId = lead.Id;
        res.leadName = lead.Name;
        res.isConverted = lead.IsConverted;
        res.status = lead.Status;

        if (lead.IsConverted) {
            res.accountId = lead.ConvertedAccountId;
            res.contactId = lead.ConvertedContactId;
            res.opportunityId = lead.ConvertedOpportunityId;
            res.message = 'Lead is already converted.';
            return res;
        }

        // Perform conversion
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(getConvertedStatus());
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(lead.Company + ' - ' + lead.Name);

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            res.accountId = lcr.getAccountId();
            res.contactId = lcr.getContactId();
            res.opportunityId = lcr.getOpportunityId();
            res.message = 'Lead converted successfully.';
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getMessage() + '; ';
            }
            res.message = 'Conversion failed: ' + errors;
        }

        return res;
    }

    private static String getConvertedStatus() {
        List<LeadStatus> convertedStatuses = [
            SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1
        ];
        return convertedStatuses.isEmpty() ? 'Closed - Converted' : convertedStatuses[0].MasterLabel;
    }
}