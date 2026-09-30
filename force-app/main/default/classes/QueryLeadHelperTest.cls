@Is{!Environment.IvanTest}(SeeAllData=true)
public class QueryLeadHelper{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}
    static void findLead() {
        List<Lead> leads = [
            SELECT Id, LastName, Company
            FROM Lead
            WHERE LastName = '{!Environment.IvanTest}_Lead_1890456'
            AND Company = 'Copado'
            AND IsConverted = false
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        System.assert(!leads.isEmpty(), 'Lead not found');
        Lead l = leads[0];
        System.debug('FOUND_LEAD_ID:' + l.Id);
        System.debug('FOUND_LEAD_NAME:' + l.LastName);
        System.debug('FOUND_LEAD_COMPANY:' + l.Company);
    }
}