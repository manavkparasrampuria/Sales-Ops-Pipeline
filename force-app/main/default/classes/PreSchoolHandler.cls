/**
 * @description Handler class for PreSchool__c object business logic.
 *              Follows a trigger handler pattern to keep triggers thin.
 * @author      Copado Orchestrate Agent
 * @date        2026-09-18
 */
public with sharing class PreSchoolHandler {

    private static final String STATUS_ACTIVE   = 'Active';
    private static final String STATUS_INACTIVE = 'Inactive';

    // ─── Before Context ───────────────────────────────────────────────────────

    public static void onBeforeInsert(List<PreSchool__c> newList) {
        setDefaultValues(newList);
        validateRequiredFields(newList);
    }

    public static void onBeforeUpdate(List<PreSchool__c> newList, Map<Id, PreSchool__c> oldMap) {
        validateRequiredFields(newList);
    }

    // ─── After Context ────────────────────────────────────────────────────────

    public static void onAfterInsert(List<PreSchool__c> newList) {
        createWelcomeTask(newList);
    }

    public static void onAfterUpdate(List<PreSchool__c> newList, Map<Id, PreSchool__c> oldMap) {
        logDeactivatedSchools(newList, oldMap);
    }

    // ─── Private Helpers ──────────────────────────────────────────────────────

    private static void setDefaultValues(List<PreSchool__c> newList) {
        for (PreSchool__c school : newList) {
            if (String.isBlank(school.Status__c)) {
                school.Status__c = STATUS_ACTIVE;
            }
            if (school.Enrollment_Date__c == null) {
                school.Enrollment_Date__c = Date.today();
            }
        }
    }

    private static void validateRequiredFields(List<PreSchool__c> newList) {
        for (PreSchool__c school : newList) {
            if (String.isBlank(school.Contact_Email__c)) {
                school.Contact_Email__c.addError('Contact Email is required.');
            }
            if (school.Maximum_Capacity__c != null && school.Maximum_Capacity__c <= 0) {
                school.Maximum_Capacity__c.addError('Maximum Capacity must be a positive number.');
            }
        }
    }

    private static void createWelcomeTask(List<PreSchool__c> newList) {
        List<Task> tasksToInsert = new List<Task>();
        for (PreSchool__c school : newList) {
            Task t         = new Task();
            t.Subject      = 'Welcome - Follow up with ' + school.Name;
            t.WhatId       = school.Id;
            t.ActivityDate = Date.today().addDays(3);
            t.Status       = 'Not Started';
            t.Priority     = 'Normal';
            t.Description  = 'Initial welcome follow-up for newly registered PreSchool.';
            tasksToInsert.add(t);
        }
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    private static void logDeactivatedSchools(List<PreSchool__c> newList, Map<Id, PreSchool__c> oldMap) {
        Integer count = 0;
        for (PreSchool__c school : newList) {
            PreSchool__c oldRecord = oldMap.get(school.Id);
            if (oldRecord.Status__c == STATUS_ACTIVE && school.Status__c == STATUS_INACTIVE) {
                count++;
            }
        }
        if (count > 0) {
            System.debug(LoggingLevel.INFO, 'PreSchools deactivated: ' + count + ' record(s).');
        }
    }
}