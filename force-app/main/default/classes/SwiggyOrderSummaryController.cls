public with sharing class SwiggyOrderSummaryController {
    public class OrderWrapper {
        @AuraEnabled public Swiggy_Order__c order;
        @AuraEnabled public List<Swiggy_Order_Item__c> items;
    }

    @AuraEnabled(cacheable=true)
    public static OrderWrapper getOrderSummary(Id orderId) {
        OrderWrapper wrapper = new OrderWrapper();
        wrapper.order = [
            SELECT Id, Name, Order_Status__c, Order_Date__c, Delivery_Address__c,
                   Discount_Percent__c, Total_Amount__c, Final_Amount__c, Delivered_Date__c,
                   Restaurant__r.Name
            FROM Swiggy_Order__c
            WHERE Id = :orderId
            LIMIT 1
        ];
        wrapper.items = [
            SELECT Id, Item_Name__c, Quantity__c, Unit_Price__c, Line_Total__c
            FROM Swiggy_Order_Item__c
            WHERE Order__c = :orderId
            ORDER BY Item_Name__c
        ];
        return wrapper;
    }
}