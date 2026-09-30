public class CreateUSForProject1864260 {
    public static void run() {
        // Step 1: Query the Project
        List<copado__Project__c> projects = [SELECT Id FROM copado__Project__c WHERE Name = 'AI_SFDX_Project' LIMIT 1];
        if (projects.isEmpty()) {
            System.debug('PROJECT_NOT_FOUND');
            return;
        }
        Id projectId = projects[0].Id;

        // Step 2: Create the User Story
        copado__User_Story__c us = new copado__User_Story__c();
        us.copado__User_Story_Title__c = '{!Environment.IvanTest} User Story_1864260';
        us.copado__Project__c = projectId;
        insert us;

        // Step 3: Retrieve Name and Id
        copado__User_Story__c created = [SELECT Id, Name FROM copado__User_Story__c WHERE Id = :us.Id LIMIT 1];
        System.debug('US_ID:' + created.Id);
        System.debug('US_NAME:' + created.Name);
    }
}