public with sharing class RenewalOpportunityBatch implements Database.Batchable<SObject>, Database.Stateful {

    public static final Integer RENEWAL_WINDOW_DAYS = 60;
    public static final Decimal HEALTH_SCORE_AT_RISK_THRESHOLD = 60;

    public Integer contractsProcessed = 0;
    public Integer opportunitiesCreated = 0;
    public Integer errorsCount = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date cutoff = Date.today().addDays(RENEWAL_WINDOW_DAYS);
        return Database.getQueryLocator([
            SELECT Id, AccountId, EndDate, Total_ARR__c, Total_Discount__c,
                    Account.Customer_Health_Score__c
            FROM Contract
            WHERE Renewal_Opportunity_Created__c = false
                AND EndDate != null
                AND EndDate <= :cutoff
                AND EndDate >= TODAY
                AND Status = 'Activated'
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Contract> scope) {
        List<Opportunity> renewalsToInsert = new List<Opportunity>();
        List<Contract> contractsToUpdate = new List<Contract>();
        List<Lifecycle_Audit__c> audits = new List<Lifecycle_Audit__c>();
        Map<Integer, Id> indexToContractId = new Map<Integer, Id>();

        for (Contract con : scope) {
            contractsProcessed++;
            if (OpportunityLifecycleService.renewalExists(con.Id)) {
                continue;
            }
            Decimal previousArr = con.Total_ARR__c == null ? 0 : con.Total_ARR__c;
            Decimal renewalAmount = previousArr;
            Boolean atRisk = con.Account != null
                    && con.Account.Customer_Health_Score__c != null
                    && con.Account.Customer_Health_Score__c < HEALTH_SCORE_AT_RISK_THRESHOLD;

            Opportunity renewalOpp = new Opportunity(
                Name = 'Renewal - ' + con.Id,
                AccountId = con.AccountId,
                StageName = 'Prospecting',
                CloseDate = con.EndDate,
                Amount = renewalAmount,
                Is_Renewal__c = true,
                Renewal_Source_Contract__c = con.Id,
                Renewal_Unique_Key__c = con.Id,
                Previous_ARR__c = previousArr,
                Renewal_Amount__c = renewalAmount,
                Renewal_Increase_Percent__c = 0,
                At_Risk__c = atRisk
            );
            indexToContractId.put(renewalsToInsert.size(), con.Id);
            renewalsToInsert.add(renewalOpp);
        }

        if (renewalsToInsert.isEmpty() || !Schema.sObjectType.Opportunity.isCreateable()) {
            return;
        }

        List<Database.SaveResult> results = Database.insert(renewalsToInsert, false);
        for (Integer i = 0; i < results.size(); i++) {
            Id contractId = indexToContractId.get(i);
            if (results[i].isSuccess()) {
                opportunitiesCreated++;
                contractsToUpdate.add(new Contract(Id = contractId, Renewal_Opportunity_Created__c = true));
                audits.add(OpportunityLifecycleService.buildAudit(
                    'Renewal Opportunity Creation', 'Success',
                    'Renewal Opportunity created for Contract ' + contractId, null, contractId, null));
            } else {
                errorsCount++;
                String errMsg = results[i].getErrors().isEmpty() ? 'Unknown error' : results[i].getErrors()[0].getMessage();
                audits.add(OpportunityLifecycleService.buildAudit(
                    'Renewal Opportunity Creation', 'Error',
                    'Failed to create Renewal Opportunity for Contract ' + contractId + ': ' + errMsg, null, contractId, null));
            }
        }

        if (!contractsToUpdate.isEmpty() && Schema.sObjectType.Contract.isUpdateable()) {
            Database.update(contractsToUpdate, false);
        }
        if (!audits.isEmpty() && Schema.sObjectType.Lifecycle_Audit__c.isCreateable()) {
            Database.insert(audits, false);
        }
    }

    public void finish(Database.BatchableContext bc) {
        if (Schema.sObjectType.Lifecycle_Audit__c.isCreateable()) {
            insert OpportunityLifecycleService.buildAudit(
                'Renewal Batch Summary', errorsCount > 0 ? 'Warning' : 'Info',
                'Processed ' + contractsProcessed + ' contract(s), created ' + opportunitiesCreated
                        + ' renewal opportunity(ies), ' + errorsCount + ' error(s).', null, null, null);
        }
    }
}