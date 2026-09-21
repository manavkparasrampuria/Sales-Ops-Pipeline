public class OrderValidationEngine_M4R8 {
    
    public static Boolean validateOrder(
        Decimal orderAmount, 
        String customerType
    ) {
        if (customerType == 'Premium' && orderAmount >= 1000) {
            return true;
        }
        
        if (customerType == 'Standard' && orderAmount >= 500) {
            return true;
        }
        
        return false;
    }

    public static void testValidation() {
        Boolean isValid = OrderValidationEngine_M4R8.validateOrder(
            1500, 
            'Premium'
        );

        System.debug('Order validation result: ' + isValid);
    }
}