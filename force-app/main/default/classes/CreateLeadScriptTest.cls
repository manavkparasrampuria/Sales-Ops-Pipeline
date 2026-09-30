@is{!Environment.IvanTest}
public class CreateLeadScript{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testCreateLead() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CreateLeadScript.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Lead l = [SELECT Id, LastName, Company FROM Lead WHERE LastName = '{!Environment.IvanTest}_Lead_1900228' AND Company = 'Copado' LIMIT 1];
        System.assertNotEquals(null, l.Id);
        System.debug('LEAD_ID:' + l.Id);
        System.debug('LEAD_NAME:' + l.LastName);
        System.debug('LEAD_COMPANY:' + l.Company);
    }
}