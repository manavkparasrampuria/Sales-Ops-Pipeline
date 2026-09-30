public with sharing class OpportunityLifecycleService {
    public class FamilySummary {
        public String family;
        public Decimal totalArr = 0;
        public Decimal totalDiscount = 0;
        public Integer durationMonths = 12;
        public Boolean subscriptionEligible = false;
        public List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
    }

    public static List<OpportunityLineItem> getLineItems(Id oppId) {
        return [SELECT Id, Quantity, UnitPrice, TotalPrice, Discount,
                    Product2Id, Product2.Family, Product2.Name
                FROM OpportunityLineItem
                WHERE OpportunityId = :oppId];
    }

    public static Map<String, FamilySummary> groupByFamily(List<OpportunityLineItem> items) {
        Map<String, FamilySummary> result = new Map<String, FamilySummary>();
        Map<String, Contract_Duration_Rule__mdt> rules = getDurationRules();
        for (OpportunityLineItem li : items) {
            String fam = String.isBlank(li.Product2.Family) ? 'Other' : li.Product2.Family;
            if (!result.containsKey(fam)) {
                FamilySummary fs = new FamilySummary();
                fs.family = fam;
                Contract_Duration_Rule__mdt rule = rules.containsKey(fam) ? rules.get(fam) : rules.get('Default');
                if (rule != null) {
                    fs.durationMonths = rule.Duration_Months__c != null ? Integer.valueOf(rule.Duration_Months__c) : 12;
                    fs.subscriptionEligible = rule.Subscription_Eligible__c == true;
                }
                result.put(fam, fs);
            }
            FamilySummary fs2 = result.get(fam);
            fs2.lines.add(li);
            fs2.totalArr += (li.TotalPrice == null ? 0 : li.TotalPrice);
            fs2.totalDiscount += (li.Discount == null ? 0 : li.Discount);
        }
        return result;
    }

    public static Map<String, Contract_Duration_Rule__mdt> getDurationRules() {
        Map<String, Contract_Duration_Rule__mdt> rules = new Map<String, Contract_Duration_Rule__mdt>();
        for (Contract_Duration_Rule__mdt r : [SELECT DeveloperName, Product_Family__c,
                    Duration_Months__c, Subscription_Eligible__c
                FROM Contract_Duration_Rule__mdt]) {
            String key = String.isBlank(r.Product_Family__c) ? r.DeveloperName : r.Product_Family__c;
            rules.put(key, r);
        }
        return rules;
    }

    public static Decimal totalArr(List<OpportunityLineItem> items) {
        Decimal total = 0;
        for (OpportunityLineItem li : items) {
            total += (li.TotalPrice == null ? 0 : li.TotalPrice);
        }
        return total;
    }

    public static Decimal totalDiscount(List<OpportunityLineItem> items) {
        Decimal total = 0;
        for (OpportunityLineItem li : items) {
            total += (li.Discount == null ? 0 : li.Discount);
        }
        return total;
    }

    public static Decimal weightedAvgDiscount(List<OpportunityLineItem> items) {
        Decimal weightedSum = 0;
        Decimal totalAmount = 0;
        for (OpportunityLineItem li : items) {
            Decimal amt = (li.TotalPrice == null ? 0 : li.TotalPrice);
            Decimal disc = (li.Discount == null ? 0 : li.Discount);
            weightedSum += (amt * disc);
            totalAmount += amt;
        }
        if (totalAmount == 0) {
            return 0;
        }
        return (weightedSum / totalAmount).setScale(2);
    }

    public static Integer maxDurationMonths(Map<String, FamilySummary> byFamily) {
        Integer maxMonths = 12;
        for (FamilySummary fs : byFamily.values()) {
            if (fs.durationMonths > maxMonths) {
                maxMonths = fs.durationMonths;
            }
        }
        return maxMonths;
    }

    public static Boolean contractExists(Id oppId) {
        return ![SELECT Id FROM Contract WHERE Unique_Key__c = :oppId LIMIT 1].isEmpty();
    }

    public static Boolean renewalExists(Id contractId) {
        return ![SELECT Id FROM Opportunity WHERE Renewal_Unique_Key__c = :contractId LIMIT 1].isEmpty();
    }

    public static Boolean subscriptionExists(String uniqueKey) {
        return ![SELECT Id FROM Subscription__c WHERE Unique_Key__c = :uniqueKey LIMIT 1].isEmpty();
    }

    public static Contract buildContract(Opportunity opp, Integer durationMonths, Decimal totalArrAmt, Decimal avgDiscount) {
        return new Contract(
            AccountId = opp.AccountId,
            StartDate = Date.today(),
            ContractTerm = durationMonths,
            Status = 'Draft',
            Source_Opportunity__c = opp.Id,
            Unique_Key__c = opp.Id,
            Total_ARR__c = totalArrAmt,
            Total_Discount__c = avgDiscount
        );
    }

    public static List<Contract_Line__c> buildContractLines(Id contractId, List<OpportunityLineItem> items) {
        List<Contract_Line__c> lines = new List<Contract_Line__c>();
        for (OpportunityLineItem li : items) {
            String fam = String.isBlank(li.Product2.Family) ? 'Other' : li.Product2.Family;
            lines.add(new Contract_Line__c(
                Contract__c = contractId,
                Opportunity_Product__c = li.Id,
                Product__c = li.Product2Id,
                Product_Family__c = fam,
                Quantity__c = li.Quantity,
                Unit_Price__c = li.UnitPrice,
                Discount__c = li.Discount,
                ARR__c = li.TotalPrice
            ));
        }
        return lines;
    }

    public static List<Subscription__c> buildSubscriptions(Id contractId, Opportunity opp,
            List<OpportunityLineItem> items, Map<String, FamilySummary> byFamily, Integer durationMonths) {
        List<Subscription__c> subs = new List<Subscription__c>();
        for (OpportunityLineItem li : items) {
            String fam = String.isBlank(li.Product2.Family) ? 'Other' : li.Product2.Family;
            FamilySummary fs = byFamily.get(fam);
            if (fs == null || !fs.subscriptionEligible) {
                continue;
            }
            subs.add(new Subscription__c(
                Contract__c = contractId,
                Account__c = opp.AccountId,
                Opportunity__c = opp.Id,
                Product__c = li.Product2Id,
                Product_Family__c = fam,
                Quantity__c = li.Quantity,
                ARR__c = li.TotalPrice,
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addMonths(durationMonths),
                Status__c = 'Active',
                Unique_Key__c = String.valueOf(contractId) + '-' + String.valueOf(li.Product2Id)
            ));
        }
        return subs;
    }

    public static Lifecycle_Audit__c buildAudit(String stage, String status, String message,
            Id oppId, Id contractId, Id subscriptionId) {
        return new Lifecycle_Audit__c(
            Stage__c = stage,
            Status__c = status,
            Message__c = message,
            Related_Opportunity__c = oppId,
            Related_Contract__c = contractId,
            Related_Subscription__c = subscriptionId,
            Timestamp__c = System.now()
        );
    }
}