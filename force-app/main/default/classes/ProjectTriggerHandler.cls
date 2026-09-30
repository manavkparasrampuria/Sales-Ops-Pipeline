/**
 * @description Trigger handler for Project__c.
 *              Implements before/after insert and update logic.
 *              All trigger context variables are passed in from the trigger
 *              to keep this class unit-testable.
 */
public with sharing class ProjectTriggerHandler {

    // ─── Before Insert ───────────────────────────────────────────────────────

    /**
     * @description Sets a default Status of 'Draft' when none is provided on insert.
     * @param newRecords  Trigger.new list from the before-insert context.
     */
    public static void onBeforeInsert(List<Project__c> newRecords) {
        for (Project__c proj : newRecords) {
            if (String.isBlank(proj.Status__c)) {
                proj.Status__c = 'Draft';
            }
        }
    }

    // ─── Before Update ───────────────────────────────────────────────────────

    /**
     * @description Prevents a Completed project from being moved back to Draft.
     * @param newRecords  Trigger.new list from the before-update context.
     * @param oldMap      Trigger.oldMap from the before-update context.
     */
    public static void onBeforeUpdate(
        List<Project__c>          newRecords,
        Map<Id, Project__c>       oldMap
    ) {
        for (Project__c proj : newRecords) {
            Project__c oldProj = oldMap.get(proj.Id);
            if (oldProj.Status__c == 'Completed' && proj.Status__c == 'Draft') {
                proj.addError('A Completed project cannot be moved back to Draft status.');
            }
        }
    }

    // ─── After Insert ────────────────────────────────────────────────────────

    /**
     * @description Placeholder for after-insert logic (e.g., sending notifications).
     * @param newRecords  Trigger.new list from the after-insert context.
     */
    public static void onAfterInsert(List<Project__c> newRecords) {
        // Reserved for future after-insert processing.
    }

    // ─── After Update ────────────────────────────────────────────────────────

    /**
     * @description Placeholder for after-update logic (e.g., cascading updates).
     * @param newRecords  Trigger.new list from the after-update context.
     * @param oldMap      Trigger.oldMap from the after-update context.
     */
    public static void onAfterUpdate(
        List<Project__c>    newRecords,
        Map<Id, Project__c> oldMap
    ) {
        // Reserved for future after-update processing.
    }
}