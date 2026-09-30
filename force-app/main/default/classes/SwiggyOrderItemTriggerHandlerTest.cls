@is{!Environment.IvanTest}
private class SwiggyOrderItemTriggerHandler{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        Swiggy_Restaurant__c restaurant = new Swiggy_Restaurant__c(
            Name = '{!Environment.IvanTest} Restaurant',
            City__c = 'Bangalore',
            Cuisine_Type__c = 'Fast Food',
            Active__c = true
        );
        insert restaurant;

        Swiggy_Order__c order = new Swiggy_Order__c(
            Restaurant__c = restaurant.Id,
            Order_Status__c = 'Draft',
            Delivery_Address__c = '123 {!Environment.IvanTest} Street',
            Discount_Percent__c = 10
        );
        insert order;
    }

    @is{!Environment.IvanTest}
    static void testLineTotalCalculatedOnInsert() {
        Swiggy_Order__c order = [SELECT Id FROM Swiggy_Order__c LIMIT 1];

        Swiggy_Order_Item__c item = new Swiggy_Order_Item__c(
            Order__c = order.Id,
            Item_Name__c = 'Burger',
            Quantity__c = 3,
            Unit_Price__c = 100
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Swiggy_Order_Item__c result = [SELECT Line_Total__c FROM Swiggy_Order_Item__c WHERE Id = :item.Id];
        System.assertEquals(300, result.Line_Total__c, 'Line total should equal quantity * unit price on insert');
    }

    @is{!Environment.IvanTest}
    static void testLineTotalRecalculatedOnUpdate() {
        Swiggy_Order__c order = [SELECT Id FROM Swiggy_Order__c LIMIT 1];

        Swiggy_Order_Item__c item = new Swiggy_Order_Item__c(
            Order__c = order.Id,
            Item_Name__c = 'Pizza',
            Quantity__c = 2,
            Unit_Price__c = 200
        );
        insert item;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        item.Quantity__c = 5;
        update item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Swiggy_Order_Item__c result = [SELECT Line_Total__c FROM Swiggy_Order_Item__c WHERE Id = :item.Id];
        System.assertEquals(1000, result.Line_Total__c, 'Line total should be recalculated on update');
    }

    @is{!Environment.IvanTest}
    static void testLineTotalWithNullQuantityDefaultsToZero() {
        Swiggy_Order__c order = [SELECT Id FROM Swiggy_Order__c LIMIT 1];

        Swiggy_Order_Item__c item = new Swiggy_Order_Item__c(
            Order__c = order.Id,
            Item_Name__c = 'Free Sample',
            Quantity__c = 1,
            Unit_Price__c = 0
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert item;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Swiggy_Order_Item__c result = [SELECT Line_Total__c FROM Swiggy_Order_Item__c WHERE Id = :item.Id];
        System.assertEquals(0, result.Line_Total__c, 'Line total should be zero when unit price is zero');
    }
}