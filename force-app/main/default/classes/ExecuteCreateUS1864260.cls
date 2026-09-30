public class ExecuteCreateUS1864260 {
    public static String execute() {
        // Step 1: Query the Project
        List<copado__Project__c> projects = [SELECT Id FROM copado__Project__c WHERE Name = 'AI_SFDX_Project' LIMIT 1];
        if (projects.isEmpty()) {
            return '{"error":"PROJECT_NOT_FOUND"}';
        }
        Id projectId = projects[0].Id;

        // Step 2: Create the User Story
        copado__User_Story__c us = new copado__User_Story__c();
        us.copado__User_Story_Title__c = '{!Environment.IvanTest} User Story_1864260';
        us.copado__Project__c = projectId;
        insert us;

        // Step 3: Retrieve Name and Id
        copado__User_Story__c created = [SELECT Id, Name FROM copado__User_Story__c WHERE Id = :us.Id LIMIT 1];
        return '{"id":"' + created.Id + '","name":"' + created.Name + '"}';
    }
}