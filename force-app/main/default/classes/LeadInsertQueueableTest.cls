@Is{!Environment.IvanTest}
public class LeadInsertQueueable{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}
    static void testEnqueue() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        System.enqueueJob(new LeadInsertQueueable());
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Lead l = [SELECT Id, LastName, Company FROM Lead WHERE LastName = '{!Environment.IvanTest}_Lead_1890456' AND Company = 'Copado' LIMIT 1];
        System.debug('QUEUEABLE_LEAD_ID:' + l.Id);
        System.debug('QUEUEABLE_LEAD_NAME:' + l.LastName);
        System.debug('QUEUEABLE_LEAD_COMPANY:' + l.Company);
        System.assertNotEquals(null, l.Id);
    }
}