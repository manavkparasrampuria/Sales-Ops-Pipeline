public class CreateCopado{!Environment.IvanTest}Lead {
    public static void run() {
        Lead l = new Lead();
        l.LastName = '{!Environment.IvanTest}_Lead_1890456';
        l.Company = 'Copado';
        insert l;
        System.debug('LEAD_ID:' + l.Id);
        System.debug('LEAD_NAME:' + l.LastName);
        System.debug('LEAD_COMPANY:' + l.Company);
    }
}