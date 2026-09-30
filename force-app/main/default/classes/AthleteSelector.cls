public with sharing class AthleteSelector {
    @AuraEnabled(cacheable=true)
    public static List<Athlete__c> getTopAthletes() {
        return [
            SELECT Id, Name, Ranking__c, Score__c, Country__c, Score_Grade__c
            FROM Athlete__c
            WITH SECURITY_ENFORCED
            ORDER BY Score__c DESC NULLS LAST
            LIMIT 5
        ];
    }
}