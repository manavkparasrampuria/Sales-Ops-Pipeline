public with sharing class MachaServiceController {

    @AuraEnabled(cacheable=true)
    public static List<Macha__c> getMachaRecords(String status) {
        if (String.isBlank(status)) {
            return [
                SELECT Id, Name, Status__c, Priority__c, Assigned_To__c,
                       Due_Date__c, Is_Active__c, Estimated_Hours__c, Actual_Hours__c
                FROM Macha__c
                ORDER BY CreatedDate DESC
                LIMIT 200
            ];
        }
        return [
            SELECT Id, Name, Status__c, Priority__c, Assigned_To__c,
                   Due_Date__c, Is_Active__c, Estimated_Hours__c, Actual_Hours__c
            FROM Macha__c
            WHERE Status__c = :status
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }

    @AuraEnabled
    public static Macha__c saveMachaRecord(Macha__c record) {
        if (record == null) {
            AuraHandledException ex = new AuraHandledException('Invalid record: record cannot be null.');
            ex.setMessage('Invalid record: record cannot be null.');
            throw ex;
        }
        try {
            upsert record;
            return record;
        } catch (DmlException e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw ex;
        }
    }

    @AuraEnabled
    public static void deleteMachaRecord(Id recordId) {
        if (recordId == null) {
            AuraHandledException ex = new AuraHandledException('Invalid record Id: Id cannot be null.');
            ex.setMessage('Invalid record Id: Id cannot be null.');
            throw ex;
        }
        try {
            Macha__c rec = [SELECT Id FROM Macha__c WHERE Id = :recordId LIMIT 1];
            delete rec;
        } catch (DmlException e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw ex;
        }
    }
}