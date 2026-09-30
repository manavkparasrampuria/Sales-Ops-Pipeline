@is{!Environment.IvanTest}
public class ExecuteCreateUS1864260{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testExecute() {
        copado__Project__c proj = new copado__Project__c(Name = 'AI_SFDX_Project');
        insert proj;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = ExecuteCreateUS1864260.execute();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result);
        System.assert(result.contains('"id"'), 'Result should contain id');
        System.assert(result.contains('"name"'), 'Result should contain name');
    }
}