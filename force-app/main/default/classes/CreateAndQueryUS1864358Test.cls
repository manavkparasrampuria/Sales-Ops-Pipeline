@is{!Environment.IvanTest}
public class CreateAndQueryUS1864358{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testCreateAndQuery() {
        copado__Project__c proj = new copado__Project__c(Name = 'AI_SFDX_Project');
        insert proj;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CreateAndQueryUS1864358.createAndQuery();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, CreateAndQueryUS1864358.resultId, 'User Story ID should not be null');
        System.assertNotEquals(null, CreateAndQueryUS1864358.resultName, 'User Story Name should not be null');
        System.debug('FINAL_ID:' + CreateAndQueryUS1864358.resultId);
        System.debug('FINAL_NAME:' + CreateAndQueryUS1864358.resultName);
    }
}