@is{!Environment.IvanTest}
public class Find{!Environment.IvanTest}Lead{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void queryLead() {
        Lead l = new Lead();
        l.LastName = '{!Environment.IvanTest}_Lead_1890456';
        l.Company = 'Copado';
        insert l;

        Lead inserted = [SELECT Id, LastName, Company FROM Lead WHERE Id = :l.Id LIMIT 1];
        System.debug('LEAD_ID:' + inserted.Id);
        System.debug('LEAD_NAME:' + inserted.LastName);
        System.debug('LEAD_COMPANY:' + inserted.Company);
        System.assert(true);
    }
}