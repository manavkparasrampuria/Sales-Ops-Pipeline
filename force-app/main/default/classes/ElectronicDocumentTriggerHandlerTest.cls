@is{!Environment.IvanTest}
private class ElectronicDocumentTriggerHandler{!Environment.IvanTest} {

    @is{!Environment.IvanTest} static void testBeforeInsertDefaults() {
        Electronic_Document__c doc = new Electronic_Document__c(Name='Trigger {!Environment.IvanTest} Doc');
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); insert doc; {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        Electronic_Document__c r = [SELECT EM_Status__c, EM_Version__c FROM Electronic_Document__c WHERE Id=:doc.Id];
        System.assertEquals('Draft', r.EM_Status__c);
        System.assertEquals(1, r.EM_Version__c);
    }

    @is{!Environment.IvanTest} static void testCannotRevertApprovedToDraft() {
        ElectronicDocumentTriggerHandler.bypassTrigger = true;
        Electronic_Document__c doc = new Electronic_Document__c(Name='Approved Doc', EM_Document_Type__c='Contract', EM_Status__c='Approved', EM_Version__c=1);
        insert doc;
        ElectronicDocumentTriggerHandler.bypassTrigger = false;
        doc.EM_Status__c = 'Draft';
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try { update doc; System.assert(false, 'Expected DmlException'); } catch (DmlException e) { System.assert(e.getMessage().length() > 0); }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest} static void testCannotEditArchivedDocument() {
        ElectronicDocumentTriggerHandler.bypassTrigger = true;
        Electronic_Document__c doc = new Electronic_Document__c(Name='Archived Doc', EM_Document_Type__c='Invoice', EM_Status__c='Archived', EM_Version__c=1);
        insert doc;
        ElectronicDocumentTriggerHandler.bypassTrigger = false;
        doc.EM_Description__c = 'Trying to edit archived doc';
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try { update doc; System.assert(false, 'Expected DmlException'); } catch (DmlException e) { System.assert(e.getMessage().length() > 0); }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest} static void testBypassTrigger() {
        ElectronicDocumentTriggerHandler.bypassTrigger = true;
        Electronic_Document__c doc = new Electronic_Document__c(Name='Bypass {!Environment.IvanTest} Doc');
        {!Environment.IvanTest}.start{!Environment.IvanTest}(); insert doc; {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        ElectronicDocumentTriggerHandler.bypassTrigger = false;
        System.assertNotEquals(null, doc.Id);
    }
}