public class GetLeadId {
    public static void run() {
        List<Lead> leads = [SELECT Id, LastName, Company FROM Lead WHERE LastName = '{!Environment.IvanTest}_Lead_1900228' AND Company = 'Copado' ORDER BY CreatedDate DESC LIMIT 1];
        if (!leads.isEmpty()) {
            System.debug('RESULT_ID=' + leads[0].Id);
            System.debug('RESULT_NAME=' + leads[0].LastName);
            System.debug('RESULT_COMPANY=' + leads[0].Company);
        }
    }
}