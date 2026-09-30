public with sharing class ElectronicDocumentController {

    @AuraEnabled(cacheable=true)
    public static List<Electronic_Document__c> getDocuments(String statusFilter) {
        String soql = 'SELECT Id, Name, EM_Document_Type__c, EM_Status__c, EM_Expiry_Date__c, EM_Version__c, EM_Is_Confidential__c, EM_Days_Until_Expiry__c FROM Electronic_Document__c';
        if (String.isNotBlank(statusFilter)) { soql += ' WHERE EM_Status__c = \'' + String.escapeSingleQuotes(statusFilter) + '\''; }
        soql += ' ORDER BY CreatedDate DESC LIMIT 200';
        return Database.query(soql);
    }

    @AuraEnabled
    public static void submitForReview(Id documentId) { ElectronicDocumentService.submitForReview(new List<Id>{ documentId }); }

    @AuraEnabled
    public static void approveDocument(Id documentId) { ElectronicDocumentService.approveDocuments(new List<Id>{ documentId }); }

    @AuraEnabled
    public static void rejectDocument(Id documentId) { ElectronicDocumentService.rejectDocuments(new List<Id>{ documentId }); }

    @AuraEnabled
    public static void archiveDocument(Id documentId) { ElectronicDocumentService.archiveDocuments(new List<Id>{ documentId }); }
}