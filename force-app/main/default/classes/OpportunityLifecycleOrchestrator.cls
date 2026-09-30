/**
 * @description Orchestrates the Opportunity Closed Won -> Contract -> Contract Line ->
 *              Subscription automation. Processes each Opportunity independently so a
 *              failure on one record does not block the others (fault tolerant),
 *              logging outcomes to Lifecycle_Audit__c.
 */
public with sharing class OpportunityLifecycleOrchestrator {

    public static void processClosedWon(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        List<Lifecycle_Audit__c> auditLog = new List<Lifecycle_Audit__c>();
        for (Opportunity opp : newList) {
            if (!isNewlyClosedWon(opp, oldMap)) {
                continue;
            }
            Savepoint sp = Database.setSavepoint();
            try {
                processOneOpportunity(opp, auditLog);
            } catch (Exception e) {
                Database.rollback(sp);
                auditLog.add(OpportunityLifecycleService.buildAudit(
                    'Error', 'Failed',
                    'Unhandled exception processing Opportunity ' + opp.Id + ': ' + e.getMessage() + ' | ' + e.getStackTraceString(),
                    opp.Id, null, null));
            }
        }
        insertAuditRecords(auditLog);
    }

    private static Boolean isNewlyClosedWon(Opportunity opp, Map<Id, Opportunity> oldMap) {
        if (opp.StageName != 'Closed Won') {
            return false;
        }
        if (oldMap == null) {
            return true;
        }
        Opportunity oldOpp = oldMap.get(opp.Id);
        return oldOpp.StageName != 'Closed Won';
    }

    private static void processOneOpportunity(Opportunity opp, List<Lifecycle_Audit__c> auditLog) {
        if (OpportunityLifecycleService.contractExists(opp.Id)) {
            auditLog.add(OpportunityLifecycleService.buildAudit(
                'Contract Creation', 'Info',
                'Contract already exists for Opportunity ' + opp.Id + ', skipping.', opp.Id, null, null));
            return;
        }

        List<OpportunityLineItem> items = OpportunityLifecycleService.getLineItems(opp.Id);
        if (items.isEmpty()) {
            auditLog.add(OpportunityLifecycleService.buildAudit(
                'Opportunity Closed Won', 'Warning',
                'Opportunity ' + opp.Id + ' has no line items. Contract not created.', opp.Id, null, null));
            return;
        }

        Map<String, OpportunityLifecycleService.FamilySummary> byFamily = OpportunityLifecycleService.groupByFamily(items);
        Decimal totalArrAmt = OpportunityLifecycleService.totalArr(items);
        Decimal avgDiscount = OpportunityLifecycleService.weightedAvgDiscount(items);
        Integer durationMonths = OpportunityLifecycleService.maxDurationMonths(byFamily);

        Contract con = OpportunityLifecycleService.buildContract(opp, durationMonths, totalArrAmt, avgDiscount);
        if (!Schema.sObjectType.Contract.isCreateable()) {
            auditLog.add(OpportunityLifecycleService.buildAudit(
                'Contract Creation', 'Failed', 'Insufficient access to create Contract.', opp.Id, null, null));
            return;
        }
        insert con;
        auditLog.add(OpportunityLifecycleService.buildAudit(
            'Contract Creation', 'Success', 'Contract ' + con.Id + ' created from Opportunity ' + opp.Id + '.',
            opp.Id, con.Id, null));

        List<Contract_Line__c> lines = OpportunityLifecycleService.buildContractLines(con.Id, items);
        if (!lines.isEmpty() && Schema.sObjectType.Contract_Line__c.isCreateable()) {
            insert lines;
            auditLog.add(OpportunityLifecycleService.buildAudit(
                'Contract Line Creation', 'Success', lines.size() + ' Contract Line(s) created for Contract ' + con.Id + '.',
                opp.Id, con.Id, null));
        }

        List<Subscription__c> subs = OpportunityLifecycleService.buildSubscriptions(con.Id, opp, items, byFamily, durationMonths);
        if (!subs.isEmpty() && Schema.sObjectType.Subscription__c.isCreateable()) {
            insert subs;
            auditLog.add(OpportunityLifecycleService.buildAudit(
                'Subscription Creation', 'Success', subs.size() + ' Subscription(s) created for Contract ' + con.Id + '.',
                opp.Id, con.Id, null));
        }
    }

    private static void insertAuditRecords(List<Lifecycle_Audit__c> auditLog) {
        if (!auditLog.isEmpty() && Schema.sObjectType.Lifecycle_Audit__c.isCreateable()) {
            Database.insert(auditLog, false);
        }
    }
}