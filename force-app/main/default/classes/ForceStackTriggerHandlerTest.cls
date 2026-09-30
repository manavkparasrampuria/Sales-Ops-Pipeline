@Is{!Environment.IvanTest}
private class ForceStackTriggerHandler{!Environment.IvanTest} {

    private static ForceStack__c createForceStack(String name, String status, String stage) {
        ForceStack__c fs = new ForceStack__c(
            Name             = name,
            Status__c        = status,
            Environment__c   = 'Development',
            Pipeline_Stage__c = stage,
            Is_Active__c     = true
        );
        insert fs;
        return fs;
    }

    @Is{!Environment.IvanTest}
    static void testAutoSetDeploymentDateOnDeploy() {
        ForceStack__c fs = createForceStack('Deploy {!Environment.IvanTest}', 'Draft', 'Commit');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        fs.Pipeline_Stage__c = 'Deploy';
        update fs;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceStack__c updated = [SELECT Deployment_Date__c FROM ForceStack__c WHERE Id = :fs.Id];
        Assert.areEqual(Date.today(), updated.Deployment_Date__c,
            'Deployment Date should be auto-set to today when stage moves to Deploy.');
    }

    @Is{!Environment.IvanTest}
    static void testAutoSetDeploymentDateOnReleased() {
        ForceStack__c fs = createForceStack('Released {!Environment.IvanTest}', 'Active', 'Promote');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        fs.Pipeline_Stage__c = 'Released';
        update fs;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceStack__c updated = [SELECT Deployment_Date__c FROM ForceStack__c WHERE Id = :fs.Id];
        Assert.areEqual(Date.today(), updated.Deployment_Date__c,
            'Deployment Date should be auto-set to today when stage moves to Released.');
    }

    @Is{!Environment.IvanTest}
    static void testStatusChangeAuditTrail() {
        ForceStack__c fs = createForceStack('Audit {!Environment.IvanTest}', 'Draft', 'Commit');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        fs.Status__c = 'Active';
        update fs;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceStack__c updated = [SELECT Description__c FROM ForceStack__c WHERE Id = :fs.Id];
        Assert.isTrue(
            updated.Description__c != null
                && updated.Description__c.contains('Status changed from Draft to Active'),
            'Description should contain the audit trail note after a status change.'
        );
    }

    @Is{!Environment.IvanTest}
    static void testNoAuditTrailWhenStatusUnchanged() {
        ForceStack__c fs = createForceStack('No Audit {!Environment.IvanTest}', 'Draft', 'Commit');

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        fs.Project_Reference__c = 'REF-999';
        update fs;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceStack__c updated = [SELECT Description__c FROM ForceStack__c WHERE Id = :fs.Id];
        Assert.isTrue(
            updated.Description__c == null || !updated.Description__c.contains('Status changed'),
            'Description should NOT contain an audit note when Status did not change.'
        );
    }

    @Is{!Environment.IvanTest}
    static void testDeploymentDateNotOverwrittenIfAlreadySet() {
        ForceStack__c fs = createForceStack('No Overwrite {!Environment.IvanTest}', 'Draft', 'Commit');
        Date existingDate = Date.today().addDays(-5);
        fs.Pipeline_Stage__c = 'Deploy';
        fs.Deployment_Date__c = existingDate;
        update fs;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        fs.Pipeline_Stage__c = 'Released';
        update fs;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        ForceStack__c updated = [SELECT Deployment_Date__c FROM ForceStack__c WHERE Id = :fs.Id];
        Assert.areEqual(existingDate, updated.Deployment_Date__c,
            'Deployment Date should not be overwritten if already set.');
    }
}