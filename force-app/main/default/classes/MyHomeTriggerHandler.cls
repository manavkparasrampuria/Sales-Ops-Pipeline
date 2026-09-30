public with sharing class MyHomeTriggerHandler {

    public static void handle(
        List<MyHome__c> newList,
        Map<Id, MyHome__c> oldMap,
        System.TriggerOperation operationType
    ) {
        switch on operationType {
            when BEFORE_INSERT {
                setListedDate(newList);
            }
            when BEFORE_UPDATE {
                validateStatusTransition(newList, oldMap);
            }
            when AFTER_INSERT {
                logNewHome(newList);
            }
            when AFTER_UPDATE {
                handleStatusChange(newList, oldMap);
            }
        }
    }

    private static void setListedDate(List<MyHome__c> homes) {
        for (MyHome__c home : homes) {
            if (home.Listed_Date__c == null) {
                home.Listed_Date__c = Date.today();
            }
        }
    }

    private static void validateStatusTransition(List<MyHome__c> homes, Map<Id, MyHome__c> oldMap) {
        for (MyHome__c home : homes) {
            MyHome__c oldHome = oldMap.get(home.Id);
            if (oldHome.Status__c == 'Sold' && home.Status__c == 'Available') {
                home.addError('A Sold home cannot be moved back to Available.');
            }
        }
    }

    private static void logNewHome(List<MyHome__c> homes) {
        System.debug('New MyHome__c records inserted: ' + homes.size());
    }

    private static void handleStatusChange(List<MyHome__c> homes, Map<Id, MyHome__c> oldMap) {
        for (MyHome__c home : homes) {
            MyHome__c oldHome = oldMap.get(home.Id);
            if (home.Status__c != oldHome.Status__c) {
                System.debug('Home ' + home.Name + ' status changed from ' + oldHome.Status__c + ' to ' + home.Status__c);
            }
        }
    }
}