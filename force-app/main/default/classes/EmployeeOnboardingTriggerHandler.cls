/**
 * @description Handler class for EmployeeOnboardingTrigger.
 *              Follows the one-trigger-per-object, handler-class pattern.
 * @author      Copado Build Agent
 * @date        2026-08-14
 */
public with sharing class EmployeeOnboardingTriggerHandler {

    public static void setStatusOnInsert(List<Employee_Onboarding__c> newRecords) {
        for (Employee_Onboarding__c record : newRecords) {
            record.Status__c = 'In Progress';
        }
    }
}