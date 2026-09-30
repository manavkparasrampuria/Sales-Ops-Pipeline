public with sharing class SwiggyOrderItemTriggerHandler {

    public static void calculateLineTotals(List<Swiggy_Order_Item__c> newItems) {
        for (Swiggy_Order_Item__c item : newItems) {
            Decimal quantity = item.Quantity__c != null ? item.Quantity__c : 0;
            Decimal unitPrice = item.Unit_Price__c != null ? item.Unit_Price__c : 0;
            item.Line_Total__c = quantity * unitPrice;
        }
    }
}