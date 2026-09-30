/**
 * @description Service class for retrieving Employee Onboarding records.
 *              Uses stripInaccessible for runtime FLS enforcement.
 * @author      Copado Build Agent
 * @date        2026-08-14
 */
public with sharing class EmployeeOnboardingService {

    public static List<Employee_Onboarding__c> getRecords() {
        List<Employee_Onboarding__c> records = [
            SELECT Id, Name, Employee_Name__c, Department__c, Joining_Date__c,
                   Status__c, Manager__c, Email__c, Notes__c
            FROM   Employee_Onboarding__c
            ORDER BY CreatedDate DESC
        ];
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, records);
        return (List<Employee_Onboarding__c>) decision.getRecords();
    }

    public static List<Employee_Onboarding__c> getRecordsByStatus(String status) {
        if (String.isBlank(status)) {
            return new List<Employee_Onboarding__c>();
        }
        List<Employee_Onboarding__c> records = [
            SELECT Id, Name, Employee_Name__c, Department__c, Joining_Date__c,
                   Status__c, Manager__c, Email__c, Notes__c
            FROM   Employee_Onboarding__c
            WHERE  Status__c = :status
            ORDER BY CreatedDate DESC
        ];
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, records);
        return (List<Employee_Onboarding__c>) decision.getRecords();
    }
}