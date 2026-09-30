public with sharing class ElectronicDocumentService {
    public static final String STATUS_DRAFT        = 'Draft';
    public static final String STATUS_UNDER_REVIEW = 'Under Review';
    public static final String STATUS_APPROVED     = 'Approved';
    public static final String STATUS_REJECTED     = 'Rejected';
    public static final String STATUS_ARCHIVED     = 'Archived';

    public static void submitForReview(List<Id> documentIds) {
        List<Electronic_Document__c> docs = [SELECT Id, EM_Status__c FROM Electronic_Document__c WHERE Id IN :documentIds WITH SECURITY_ENFORCED];
        List<Electronic_Document__c> toUpdate = new List<Electronic_Document__c>();
        for (Electronic_Document__c doc : docs) { if (doc.EM_Status__c == STATUS_DRAFT) { doc.EM_Status__c = STATUS_UNDER_REVIEW; toUpdate.add(doc); } }
        if (!toUpdate.isEmpty()) { update toUpdate; }
    }

    public static void approveDocuments(List<Id> documentIds) {
        List<Electronic_Document__c> docs = [SELECT Id, EM_Status__c FROM Electronic_Document__c WHERE Id IN :documentIds WITH SECURITY_ENFORCED];
        List<Electronic_Document__c> toUpdate = new List<Electronic_Document__c>();
        for (Electronic_Document__c doc : docs) { if (doc.EM_Status__c == STATUS_UNDER_REVIEW) { doc.EM_Status__c = STATUS_APPROVED; toUpdate.add(doc); } }
        if (!toUpdate.isEmpty()) { update toUpdate; }
    }

    public static void rejectDocuments(List<Id> documentIds) {
        List<Electronic_Document__c> docs = [SELECT Id, EM_Status__c FROM Electronic_Document__c WHERE Id IN :documentIds WITH SECURITY_ENFORCED];
        List<Electronic_Document__c> toUpdate = new List<Electronic_Document__c>();
        for (Electronic_Document__c doc : docs) { if (doc.EM_Status__c == STATUS_UNDER_REVIEW) { doc.EM_Status__c = STATUS_REJECTED; toUpdate.add(doc); } }
        if (!toUpdate.isEmpty()) { update toUpdate; }
    }

    public static void archiveDocuments(List<Id> documentIds) {
        List<Electronic_Document__c> docs = [SELECT Id, EM_Status__c FROM Electronic_Document__c WHERE Id IN :documentIds WITH SECURITY_ENFORCED];
        List<Electronic_Document__c> toUpdate = new List<Electronic_Document__c>();
        for (Electronic_Document__c doc : docs) { if (doc.EM_Status__c == STATUS_APPROVED || doc.EM_Status__c == STATUS_REJECTED) { doc.EM_Status__c = STATUS_ARCHIVED; toUpdate.add(doc); } }
        if (!toUpdate.isEmpty()) { update toUpdate; }
    }

    public static void incrementVersion(Id documentId) {
        Electronic_Document__c doc = [SELECT Id, EM_Version__c FROM Electronic_Document__c WHERE Id = :documentId WITH SECURITY_ENFORCED LIMIT 1];
        doc.EM_Version__c = (doc.EM_Version__c == null ? 1 : doc.EM_Version__c) + 1;
        update doc;
    }

    public static List<Electronic_Document__c> getExpiringDocuments(Integer daysAhead) {
        Date cutoff = Date.today().addDays(daysAhead);
        return [SELECT Id, Name, EM_Status__c, EM_Document_Type__c, EM_Expiry_Date__c, EM_Owner_Email__c FROM Electronic_Document__c WHERE EM_Expiry_Date__c <= :cutoff AND EM_Expiry_Date__c >= TODAY AND EM_Status__c != :STATUS_ARCHIVED WITH SECURITY_ENFORCED ORDER BY EM_Expiry_Date__c ASC];
    }
}