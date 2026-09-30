public class CreateUSForProject1864358 {
    public static String projectId;
    public static String userStoryId;
    public static String userStoryName;

    public static void run() {
        // Step 1: Query the project
        List<copado__Project__c> projects = [SELECT Id FROM copado__Project__c WHERE Name = 'AI_SFDX_Project' LIMIT 1];
        if (projects.isEmpty()) {
            System.debug('PROJECT_NOT_FOUND');
            return;
        }
        projectId = projects[0].Id;
        System.debug('PROJECT_ID:' + projectId);

        // Step 2: Create the User Story
        copado__User_Story__c us = new copado__User_Story__c();
        us.copado__User_Story_Title__c = '{!Environment.IvanTest} User Story_1864358';
        us.copado__Project__c = projectId;
        insert us;
        userStoryId = us.Id;
        System.debug('USER_STORY_ID:' + us.Id);

        // Step 3: Query back to get auto-generated Name
        copado__User_Story__c created = [SELECT Id, Name FROM copado__User_Story__c WHERE Id = :us.Id LIMIT 1];
        userStoryName = created.Name;
        System.debug('USER_STORY_NAME:' + created.Name);
    }
}