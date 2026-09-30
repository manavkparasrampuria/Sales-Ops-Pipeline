public with sharing class ProductCatalogController {

    @{!Environment.IvanTest}Visible
    private static Boolean throw{!Environment.IvanTest}Exception = false;

    @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts() {
        try {
            if ({!Environment.IvanTest}.isRunning{!Environment.IvanTest}() && throw{!Environment.IvanTest}Exception) {
                throw new QueryException('Simulated failure for test coverage');
            }
            List<Product2> products = [
                SELECT Id, Name, ProductCode, Description
                FROM Product2
                WHERE IsActive = true
                WITH USER_MODE
                ORDER BY Name ASC
                LIMIT 200
            ];
            return products;
        } catch (Exception e) {
            throw new AuraHandledException('Unable to retrieve products: ' + e.getMessage());
        }
    }
}