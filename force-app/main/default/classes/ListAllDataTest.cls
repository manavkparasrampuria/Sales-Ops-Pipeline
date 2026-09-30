@Is{!Environment.IvanTest}(SeeAllData=true)
public class ListAllData{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}
    static void listData() {
        List<copado__Environment__c> envs = [SELECT Id, Name FROM copado__Environment__c ORDER BY Name LIMIT 20];
        System.debug('ENVIRONMENTS COUNT: ' + envs.size());
        for (copado__Environment__c env : envs) {
            System.debug('ENV: ' + env.Name + ' | ID: ' + env.Id);
        }
        
        List<copado__Project__c> projects = [SELECT Id, Name FROM copado__Project__c ORDER BY Name LIMIT 10];
        System.debug('PROJECTS COUNT: ' + projects.size());
        for (copado__Project__c proj : projects) {
            System.debug('PROJECT: ' + proj.Name + ' | ID: ' + proj.Id);
        }
        
        List<copado__User_Story__c> stories = [SELECT Id, Name, copado__Project__c FROM copado__User_Story__c ORDER BY CreatedDate DESC LIMIT 5];
        System.debug('USER STORIES COUNT: ' + stories.size());
        for (copado__User_Story__c us : stories) {
            System.debug('US: ' + us.Name + ' | ID: ' + us.Id + ' | Project: ' + us.copado__Project__c);
        }
        
        System.assert(true);
    }
}