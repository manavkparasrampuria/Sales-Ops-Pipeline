public class LeadStatusCheck {
    public static String getLeadInfo() {
        List<Lead> leads = [
            SELECT Id, Name, IsConverted, Status, Company, Email,
                   ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead
            WHERE Name = '{!Environment.IvanTest}_Lead_1910334'
            LIMIT 1
        ];
        if (leads.isEmpty()) return 'NOT_FOUND';
        Lead l = leads[0];
        String result = 'Id=' + l.Id + '|Name=' + l.Name + '|IsConverted=' + l.IsConverted + '|Status=' + l.Status + '|Company=' + l.Company;
        if (l.IsConverted) {
            result += '|AccountId=' + l.ConvertedAccountId + '|ContactId=' + l.ConvertedContactId + '|OpportunityId=' + l.ConvertedOpportunityId;
        }
        return result;
    }
}