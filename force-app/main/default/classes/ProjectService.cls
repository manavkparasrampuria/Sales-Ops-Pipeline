/**
 * @description Service class for Project__c operations.
 *              Provides reusable, bulkified methods for querying and creating projects.
 * @author      Copado Build Agent
 */
public with sharing class ProjectService {

    /**
     * @description Returns all Project__c records with Status__c = 'Active'.
     * @return      List<Project__c>
     */
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getActiveProjects() {
        return [
            SELECT Id, Name, Status__c, Start_Date__c, End_Date__c,
                   Budget__c, Budget_Remaining__c, Total_Tasks__c
            FROM   Project__c
            WHERE  Status__c = 'Active'
            ORDER BY Name ASC
        ];
    }

    /**
     * @description Creates a new Project__c record with the supplied field values.
     * @param       projectName  Name of the project.
     * @param       status       Initial status value.
     * @param       startDate    Project start date.
     * @param       endDate      Project end date.
     * @param       budget       Project budget.
     * @return      Id of the newly created record.
     */
    @AuraEnabled
    public static Id createProject(
        String projectName,
        String status,
        Date   startDate,
        Date   endDate,
        Decimal budget
    ) {
        if (String.isBlank(projectName)) {
            throw new AuraHandledException('Project Name is required.');
        }
        Project__c proj = new Project__c(
            Name         = projectName,
            Status__c    = String.isBlank(status) ? 'Draft' : status,
            Start_Date__c = startDate,
            End_Date__c   = endDate,
            Budget__c     = budget
        );
        insert proj;
        return proj.Id;
    }

    /**
     * @description Returns Project__c records filtered by a given status value.
     * @param       status  The status picklist value to filter on.
     * @return      List<Project__c>
     */
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsByStatus(String status) {
        if (String.isBlank(status)) {
            return new List<Project__c>();
        }
        return [
            SELECT Id, Name, Status__c, Start_Date__c, End_Date__c,
                   Budget__c, Budget_Remaining__c, Total_Tasks__c
            FROM   Project__c
            WHERE  Status__c = :status
            ORDER BY Name ASC
        ];
    }
}