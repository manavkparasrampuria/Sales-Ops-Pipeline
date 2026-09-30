@is{!Environment.IvanTest}
private class SwiggyOrderSummaryController{!Environment.IvanTest} {
    @testSetup
    static void setup() {
        Swiggy_Restaurant__c rest = new Swiggy_Restaurant__c(
            Name = '{!Environment.IvanTest} Restaurant',
            City__c = 'Bangalore',
            Cuisine_Type__c = 'Fast Food',
            Active__c = true
        );
        insert rest;

        Swiggy_Order__c order = new Swiggy_Order__c(
            Restaurant__c = rest.Id,
            Order_Status__c = 'Draft',
            Delivery_Address__c = '123 {!Environment.IvanTest} Street',
            Discount_Percent__c = 10
        );
        insert order;

        List<Swiggy_Order_Item__c> items = new List<Swiggy_Order_Item__c>{
            new Swiggy_Order_Item__c(Order__c = order.Id, Item_Name__c = 'Burger', Quantity__c = 2, Unit_Price__c = 100),
            new Swiggy_Order_Item__c(Order__c = order.Id, Item_Name__c = 'Fries', Quantity__c = 1, Unit_Price__c = 50)
        };
        insert items;
    }

    @is{!Environment.IvanTest}
    static void testGetOrderSummary() {
        Swiggy_Order__c order = [SELECT Id FROM Swiggy_Order__c LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        SwiggyOrderSummaryController.OrderWrapper result = SwiggyOrderSummaryController.getOrderSummary(order.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result.order, 'Order should not be null');
        System.assertEquals(2, result.items.size(), 'Should return 2 order items');
    }
}