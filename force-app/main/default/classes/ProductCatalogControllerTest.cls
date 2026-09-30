@is{!Environment.IvanTest}
private class ProductCatalogController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void makeData() {
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            products.add(new Product2(
                Name = '{!Environment.IvanTest} Product ' + i,
                ProductCode = 'PC-' + i,
                Description = 'Description for product ' + i,
                IsActive = true
            ));
        }
        products.add(new Product2(
            Name = 'Inactive Product',
            ProductCode = 'PC-INACTIVE',
            Description = 'Inactive product description',
            IsActive = false
        ));
        insert products;
    }

    @is{!Environment.IvanTest}
    static void testGetProducts_PositiveBulk() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Product2> result = ProductCatalogController.getProducts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(5, result.size(), 'Only active products should be returned');
        for (Product2 p : result) {
            System.assertNotEquals(null, p.Name, 'Product name should not be null');
        }
    }

    @is{!Environment.IvanTest}
    static void testGetProducts_NoActiveProducts() {
        List<Product2> allProducts = [SELECT Id, IsActive FROM Product2];
        for (Product2 p : allProducts) {
            p.IsActive = false;
        }
        update allProducts;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Product2> result = ProductCatalogController.getProducts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(0, result.size(), 'No active products should be returned');
    }

    @is{!Environment.IvanTest}
    static void testGetProducts_FieldsPopulated() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Product2> result = ProductCatalogController.getProducts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(!result.isEmpty(), 'Result should not be empty');
        for (Product2 p : result) {
            System.assertNotEquals(null, p.ProductCode, 'Product code should be populated');
        }
    }

    @is{!Environment.IvanTest}
    static void testGetProducts_ExceptionIsHandled() {
        ProductCatalogController.throw{!Environment.IvanTest}Exception = true;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Boolean exceptionCaught = false;
        try {
            ProductCatalogController.getProducts();
        } catch (AuraHandledException ahe) {
            exceptionCaught = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(exceptionCaught, 'AuraHandledException should be thrown when an error occurs');
    }
}