public class LeadConvertHelper {
    public static Map<String, String> convertLead(String leadId, String opportunityName) {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        lc.setOpportunityName(opportunityName);
        lc.setDoNotCreateOpportunity(false);
        lc.setSendNotificationEmail(false);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        Map<String, String> result = new Map<String, String>();
        result.put('success', String.valueOf(lcr.isSuccess()));
        result.put('leadId', lcr.getLeadId());
        result.put('accountId', lcr.getAccountId());
        result.put('contactId', lcr.getContactId());
        result.put('opportunityId', lcr.getOpportunityId());
        
        if (!lcr.isSuccess()) {
            String errors = '';
            for (Database.Error e : lcr.getErrors()) {
                errors += e.getMessage() + '; ';
            }
            result.put('errors', errors);
        }
        
        return result;
    }
}