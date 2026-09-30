@is{!Environment.IvanTest}
private class ElectronicDocumentService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void makeData() {
        ElectronicDocumentTriggerHandler.bypassTrigger = true;
        List<Electronic_Document__c> docs = new List<Electronic_Document__c>{
            new Electronic_Document__c(Name='{!Environment.IvanTest} Contract',  EM_Document_Type__c='Contract', EM_Status__c='Draft',        EM_Version__c=1, EM_Expiry_Date__c=Date.today().addDays(30)),
            new Electronic_Document__c(Name='{!Environment.IvanTest} Invoice',   EM_Document_Type__c='Invoice',  EM_Status__c='Under Review', EM_Version__c=1, EM_Expiry_Date__c=Date.today().addDays(10)),
            new Electronic_Document__c(Name='{!Environment.IvanTest} Agreement', EM_Document_Type__c='Agreement',EM_Status__c='Approved',     EM_Version__c=1, EM_Expiry_Date__c=Date.today().addDays(60))
        };
        insert docs;
        ElectronicDocumentTriggerHandler.bypassTrigger = false;
    }

    @is{!Environment.IvanTest} static void testSubmitForReview() {
        Id docId = [SELECT Id FROM Electronic_Document__c WHERE Name='{!Environment.IvanTest} Contract' LIMIT 1].Id;
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); ElectronicDocumentService.submitForReview(new List<Id>{docId}); {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Under Review', [SELECT EM_Status__c FROM Electronic_Document__c WHERE Id=:docId].EM_Status__c);
    }

    @is{!Environment.IvanTest} static void testApproveDocuments() {
        Id docId = [SELECT Id FROM Electronic_Document__c WHERE Name='{!Environment.IvanTest} Invoice' LIMIT 1].Id;
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); ElectronicDocumentService.approveDocuments(new List<Id>{docId}); {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Approved', [SELECT EM_Status__c FROM Electronic_Document__c WHERE Id=:docId].EM_Status__c);
    }

    @is{!Environment.IvanTest} static void testRejectDocuments() {
        Id docId = [SELECT Id FROM Electronic_Document__c WHERE Name='{!Environment.IvanTest} Invoice' LIMIT 1].Id;
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); ElectronicDocumentService.rejectDocuments(new List<Id>{docId}); {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Rejected', [SELECT EM_Status__c FROM Electronic_Document__c WHERE Id=:docId].EM_Status__c);
    }

    @is{!Environment.IvanTest} static void testArchiveDocuments() {
        Id docId = [SELECT Id FROM Electronic_Document__c WHERE Name='{!Environment.IvanTest} Agreement' LIMIT 1].Id;
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); ElectronicDocumentService.archiveDocuments(new List<Id>{docId}); {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Archived', [SELECT EM_Status__c FROM Electronic_Document__c WHERE Id=:docId].EM_Status__c);
    }

    @is{!Environment.IvanTest} static void testIncrementVersion() {
        Electronic_Document__c doc = [SELECT Id, EM_Version__c FROM Electronic_Document__c WHERE Name='{!Environment.IvanTest} Contract' LIMIT 1];
        Decimal orig = doc.EM_Version__c;
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); ElectronicDocumentService.incrementVersion(doc.Id); {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(orig + 1, [SELECT EM_Version__c FROM Electronic_Document__c WHERE Id=:doc.Id].EM_Version__c);
    }

    @is{!Environment.IvanTest} static void testGetExpiringDocuments() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); List<Electronic_Document__c> r = ElectronicDocumentService.getExpiringDocuments(15); {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, r);
    }

    @is{!Environment.IvanTest} static void testControllerGetDocuments() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Electronic_Document__c> all    = ElectronicDocumentController.getDocuments('');
        List<Electronic_Document__c> drafts = ElectronicDocumentController.getDocuments('Draft');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, all);
        System.assertNotEquals(null, drafts);
    }

    @is{!Environment.IvanTest} static void testControllerActions() {
        Id docId = [SELECT Id FROM Electronic_Document__c WHERE Name='{!Environment.IvanTest} Contract' LIMIT 1].Id;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        ElectronicDocumentController.submitForReview(docId);
        ElectronicDocumentController.approveDocument(docId);
        ElectronicDocumentController.archiveDocument(docId);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('Archived', [SELECT EM_Status__c FROM Electronic_Document__c WHERE Id=:docId].EM_Status__c);
    }
}