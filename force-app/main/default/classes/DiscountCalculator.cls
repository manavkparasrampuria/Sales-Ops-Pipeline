public class DiscountCalculator {

    // Method to calculate discount
    public static Decimal calculateDiscount(Decimal price, Decimal discountPercent) {
        if (price == null || discountPercent == null) {
            return 0;
        }

        Decimal discountAmount = (price * discountPercent) / 100;
        Decimal finalPrice = price - discountAmount;
        return finalPrice.setScale(2); // Round to 2 decimal places
    }

}