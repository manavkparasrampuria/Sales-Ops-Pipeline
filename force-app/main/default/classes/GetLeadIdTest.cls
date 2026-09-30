@is{!Environment.IvanTest}
public class GetLeadId{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testGetLeadId() {
        Lead l = new Lead(LastName = '{!Environment.IvanTest}_Lead_1900228', Company = 'Copado');
        insert l;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        GetLeadId.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Lead queried = [SELECT Id, LastName, Company FROM Lead WHERE Id = :l.Id LIMIT 1];
        System.assertEquals('{!Environment.IvanTest}_Lead_1900228', queried.LastName);
        System.assertEquals('Copado', queried.Company);
        System.debug('FINAL_LEAD_ID=' + queried.Id);
    }
}