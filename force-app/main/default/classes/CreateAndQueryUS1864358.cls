public class CreateAndQueryUS1864358 {
    public static String resultId;
    public static String resultName;

    public static void createAndQuery() {
        List<copado__Project__c> projects = [SELECT Id FROM copado__Project__c WHERE Name = 'AI_SFDX_Project' LIMIT 1];
        if (projects.isEmpty()) {
            System.debug('PROJECT_NOT_FOUND');
            return;
        }
        copado__User_Story__c us = new copado__User_Story__c();
        us.copado__User_Story_Title__c = '{!Environment.IvanTest} User Story_1864358';
        us.copado__Project__c = projects[0].Id;
        insert us;
        copado__User_Story__c created = [SELECT Id, Name FROM copado__User_Story__c WHERE Id = :us.Id LIMIT 1];
        resultId = created.Id;
        resultName = created.Name;
        System.debug('RESULT_ID:' + created.Id);
        System.debug('RESULT_NAME:' + created.Name);
    }
}