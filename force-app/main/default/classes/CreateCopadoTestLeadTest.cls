@Is{!Environment.IvanTest}
public class CreateCopado{!Environment.IvanTest}Lead{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}(SeeAllData=true)
    static void testRun() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CreateCopado{!Environment.IvanTest}Lead.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Lead inserted = [SELECT Id, LastName, Company FROM Lead WHERE LastName = '{!Environment.IvanTest}_Lead_1890456' AND Company = 'Copado' ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('LEAD_ID:' + inserted.Id);
        System.debug('LEAD_NAME:' + inserted.LastName);
        System.debug('LEAD_COMPANY:' + inserted.Company);
        System.assertNotEquals(null, inserted.Id);
    }
}