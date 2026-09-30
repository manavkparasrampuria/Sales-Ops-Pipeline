@is{!Environment.IvanTest}
private class ForceHubTriggerHandler{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testInsertWithStatusClosed_SetsClosedDate() {
        ForceHub__c fh = new ForceHub__c(Name = '{!Environment.IvanTest} Hub 1', Status__c = 'Closed', Amount__c = 100);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert fh;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceHub__c result = [SELECT Closed_Date__c FROM ForceHub__c WHERE Id = :fh.Id];
        System.assertEquals(Date.today(), result.Closed_Date__c, 'Closed_Date__c should be set on insert when Status__c is Closed');
    }

    @is{!Environment.IvanTest}
    static void testInsertWithStatusNew_DoesNotSetClosedDate() {
        ForceHub__c fh = new ForceHub__c(Name = '{!Environment.IvanTest} Hub 2', Status__c = 'New', Amount__c = 50);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert fh;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceHub__c result = [SELECT Closed_Date__c FROM ForceHub__c WHERE Id = :fh.Id];
        System.assertEquals(null, result.Closed_Date__c, 'Closed_Date__c should remain null when Status__c is not Closed');
    }

    @is{!Environment.IvanTest}
    static void testUpdateStatusToClosed_SetsClosedDate() {
        ForceHub__c fh = new ForceHub__c(Name = '{!Environment.IvanTest} Hub 3', Status__c = 'New', Amount__c = 75);
        insert fh;

        fh.Status__c = 'Closed';
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update fh;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceHub__c result = [SELECT Closed_Date__c FROM ForceHub__c WHERE Id = :fh.Id];
        System.assertEquals(Date.today(), result.Closed_Date__c, 'Closed_Date__c should be set on update when Status__c changes to Closed');
    }

    @is{!Environment.IvanTest}
    static void testUpdateStatusAlreadyClosed_DoesNotOverwriteClosedDate() {
        ForceHub__c fh = new ForceHub__c(Name = '{!Environment.IvanTest} Hub 4', Status__c = 'Closed', Amount__c = 30, Closed_Date__c = Date.today().addDays(-5));
        insert fh;

        fh.Amount__c = 40;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        update fh;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceHub__c result = [SELECT Closed_Date__c FROM ForceHub__c WHERE Id = :fh.Id];
        System.assertEquals(Date.today().addDays(-5), result.Closed_Date__c, 'Closed_Date__c should not be overwritten if already set');
    }

    @is{!Environment.IvanTest}
    static void testValidationRule_NegativeAmountBlocked() {
        ForceHub__c fh = new ForceHub__c(Name = '{!Environment.IvanTest} Hub 5', Status__c = 'New', Amount__c = -10);
        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert fh;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Amount must be a positive value'), 'Expected validation rule error message');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals(true, exceptionThrown, 'Inserting a negative Amount__c should throw a DmlException');
    }
}