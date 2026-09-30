public class OrderDetails {
    public String customerName;
    public String orderId;
    public Decimal orderAmount;
    public String orderStatus;
    
    public OrderDetails(String customerName, String orderId, Decimal orderAmount, String orderStatus) {
        this.customerName = customerName;
        this.orderId = orderId;
        this.orderAmount = orderAmount;
        this.orderStatus = orderStatus;
    }
}