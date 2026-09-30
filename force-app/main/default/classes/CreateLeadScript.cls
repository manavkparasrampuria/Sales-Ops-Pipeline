public class CreateLeadScript {
    public static void run() {
        Lead newLead = new Lead(LastName = '{!Environment.IvanTest}_Lead_1900228', Company = 'Copado');
        insert newLead;
        System.debug('LEAD_ID:' + newLead.Id);
        System.debug('LEAD_NAME:' + newLead.LastName);
        System.debug('LEAD_COMPANY:' + newLead.Company);
    }
}