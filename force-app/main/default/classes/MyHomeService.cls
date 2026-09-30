public with sharing class MyHomeService {

    @AuraEnabled(cacheable=true)
    public static List<MyHome__c> getAvailableHomes() {
        return [
            SELECT Id, Name, Address__c, Price__c, Status__c,
                   Bedrooms__c, Bathrooms__c, Square_Footage__c,
                   Listed_Date__c, Is_Featured__c,
                   Price_Per_SqFt__c, Days_On_Market__c
            FROM MyHome__c
            WHERE Status__c = 'Available'
            ORDER BY Listed_Date__c DESC
            LIMIT 200
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<MyHome__c> getFeaturedHomes() {
        return [
            SELECT Id, Name, Address__c, Price__c, Status__c,
                   Bedrooms__c, Bathrooms__c, Square_Footage__c,
                   Listed_Date__c, Is_Featured__c,
                   Price_Per_SqFt__c, Days_On_Market__c
            FROM MyHome__c
            WHERE Is_Featured__c = true
            ORDER BY Price__c ASC
            LIMIT 50
        ];
    }

    @AuraEnabled
    public static void updateHomeStatus(Id homeId, String newStatus) {
        if (homeId == null || String.isBlank(newStatus)) {
            throw new MyHomeException('Home ID and Status are required.');
        }
        MyHome__c home = new MyHome__c(Id = homeId, Status__c = newStatus);
        update home;
    }

    @AuraEnabled
    public static void markAsFeatured(Id homeId) {
        if (homeId == null) {
            throw new MyHomeException('Home ID is required.');
        }
        MyHome__c home = new MyHome__c(Id = homeId, Is_Featured__c = true);
        update home;
    }

    public class MyHomeException extends Exception {}
}