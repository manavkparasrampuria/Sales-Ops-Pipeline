@is{!Environment.IvanTest}
public class CreateUSForProject1864358{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testRun() {
        copado__Project__c proj = new copado__Project__c(Name = 'AI_SFDX_Project');
        insert proj;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CreateUSForProject1864358.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<copado__User_Story__c> stories = [SELECT Id, Name, copado__User_Story_Title__c FROM copado__User_Story__c WHERE copado__User_Story_Title__c = '{!Environment.IvanTest} User Story_1864358'];
        System.assert(!stories.isEmpty(), 'User Story should have been created');
        System.debug('TEST_USER_STORY_ID:' + stories[0].Id);
        System.debug('TEST_USER_STORY_NAME:' + stories[0].Name);
    }
}