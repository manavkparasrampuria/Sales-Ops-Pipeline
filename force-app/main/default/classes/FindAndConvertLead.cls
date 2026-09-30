public class FindAndConvertLead {
    public static String run() {
        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Name, Email, Company, IsConverted,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId, Status
            FROM Lead
            WHERE Name LIKE '%{!Environment.IvanTest}_Lead_1921134%'
            LIMIT 5
        ];

        if (leads.isEmpty()) {
            return '###RESULT### NO_LEAD_FOUND';
        }

        String info = '';
        for (Lead l : leads) {
            info += '###LEAD### Id=' + l.Id + ' | Name=' + l.Name + ' | IsConverted=' + l.IsConverted + ' | Status=' + l.Status + ' | Company=' + l.Company + '\n';
        }

        Lead lead = leads[0];

        if (lead.IsConverted) {
            return info + '###RESULT### ALREADY_CONVERTED | ConvertedAccountId=' + lead.ConvertedAccountId + ' | ConvertedContactId=' + lead.ConvertedContactId + ' | ConvertedOpportunityId=' + lead.ConvertedOpportunityId;
        }

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName(lead.Name + ' - Opportunity');

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        if (lcr.isSuccess()) {
            return info + '###RESULT### SUCCESS | LeadId=' + lcr.getLeadId() + ' | AccountId=' + lcr.getAccountId() + ' | ContactId=' + lcr.getContactId() + ' | OpportunityId=' + lcr.getOpportunityId();
        } else {
            String errors = '';
            for (Database.Error err : lcr.getErrors()) {
                errors += err.getStatusCode() + ': ' + err.getMessage() + '; ';
            }
            return info + '###RESULT### ERROR | ' + errors;
        }
    }
}