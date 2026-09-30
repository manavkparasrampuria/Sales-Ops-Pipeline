/**
 * @description Handler class for Station__c trigger logic.
 *              Follows the single-trigger, handler-class pattern.
 * @author      Copado Build Agent
 */
public with sharing class StationTriggerHandler {

    /**
     * @description Called from trigger on before insert context.
     * @param newList List of new Station__c records.
     */
    public static void onBeforeInsert(List<Station__c> newList) {
        setDefaultStatus(newList);
    }

    /**
     * @description Called from trigger on before update context.
     * @param newList List of updated Station__c records.
     * @param oldMap  Map of old Station__c records by Id.
     */
    public static void onBeforeUpdate(List<Station__c> newList, Map<Id, Station__c> oldMap) {
        validateStatusChange(newList, oldMap);
    }

    /**
     * @description Called from trigger on after insert context.
     * @param newList List of new Station__c records.
     */
    public static void onAfterInsert(List<Station__c> newList) {
        logStationActivity(newList);
    }

    /**
     * @description Called from trigger on after update context.
     * @param newList List of updated Station__c records.
     * @param oldMap  Map of old Station__c records by Id.
     */
    public static void onAfterUpdate(List<Station__c> newList, Map<Id, Station__c> oldMap) {
        logStationActivity(newList);
    }

    // ─── Private Helpers ────────────────────────────────────────────────────

    private static void setDefaultStatus(List<Station__c> newList) {
        for (Station__c station : newList) {
            if (String.isBlank(station.Status__c)) {
                station.Status__c = 'Active';
            }
        }
    }

    private static void validateStatusChange(List<Station__c> newList, Map<Id, Station__c> oldMap) {
        for (Station__c station : newList) {
            Station__c oldStation = oldMap.get(station.Id);
            if (oldStation.Status__c == 'Active'
                    && station.Status__c == 'Inactive'
                    && String.isBlank(station.Description__c)) {
                station.addError('A Description is required when changing Status from Active to Inactive.');
            }
        }
    }

    private static void logStationActivity(List<Station__c> newList) {
        for (Station__c station : newList) {
            System.debug('Station activity: ' + station.Name + ' | Status: ' + station.Status__c);
        }
    }
}