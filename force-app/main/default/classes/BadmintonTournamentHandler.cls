public with sharing class BadmintonTournamentHandler {

    public static void handleBeforeInsert(List<Badminton_Tournament__c> newList) {
        validateTournamentDates(newList);
    }

    public static void handleBeforeUpdate(List<Badminton_Tournament__c> newList, Map<Id, Badminton_Tournament__c> oldMap) {
        validateTournamentDates(newList);
    }

    public static void handleAfterInsert(List<Badminton_Tournament__c> newList) {
        updateTotalMatches(newList);
    }

    public static void handleAfterUpdate(List<Badminton_Tournament__c> newList, Map<Id, Badminton_Tournament__c> oldMap) {
        updateTotalMatches(newList);
    }

    private static void validateTournamentDates(List<Badminton_Tournament__c> tournaments) {
        for (Badminton_Tournament__c t : tournaments) {
            if (t.Start_Date__c != null && t.End_Date__c != null) {
                if (t.End_Date__c < t.Start_Date__c) {
                    t.End_Date__c.addError('End Date cannot be before Start Date.');
                }
            }
        }
    }

    private static void updateTotalMatches(List<Badminton_Tournament__c> tournaments) {
        Set<Id> tournamentIds = new Set<Id>();
        for (Badminton_Tournament__c t : tournaments) {
            tournamentIds.add(t.Id);
        }
        // Placeholder for future roll-up logic via related matches
        System.debug('Tournament IDs processed: ' + tournamentIds);
    }
}