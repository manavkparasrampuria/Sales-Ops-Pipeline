@is{!Environment.IvanTest}
public class RunCreateUS1864358{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testExecute() {
        copado__Project__c proj = new copado__Project__c(Name = 'AI_SFDX_Project');
        insert proj;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        RunCreateUS1864358.execute();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, CreateAndQueryUS1864358.resultId);
        System.assertNotEquals(null, CreateAndQueryUS1864358.resultName);
    }
}