public class CustomerInsightProcessor_X7Q9 {
    
    public String customerName;
    public Integer score;

    public CustomerInsightProcessor_X7Q9(String name, Integer customerScore) {
        customerName = name;
        score = customerScore;
    }

    public String generateInsight() {
        if (score >= 80) {
            return customerName + ' is a high-priority customer.';
        } else if (score >= 50) {
            return customerName + ' is a medium-priority customer.';
        } else {
            return customerName + ' is a low-priority customer.';
        }
    }

    public static void processCustomer() {
        CustomerInsightProcessor_X7Q9 insight = 
            new CustomerInsightProcessor_X7Q9('Demo Customer', 85);

        System.debug(insight.generateInsight());
    }
}