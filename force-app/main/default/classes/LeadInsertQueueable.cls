public class LeadInsertQueueable implements Queueable {
    public void execute(QueueableContext context) {
        Lead l = new Lead();
        l.LastName = '{!Environment.IvanTest}_Lead_1890456';
        l.Company = 'Copado';
        insert l;
        System.debug('QUEUEABLE_LEAD_ID:' + l.Id);
    }
}