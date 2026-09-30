public class SimpleATM {
    
    // Instance variable to hold account balance
    private Decimal balance;
    
    // Constructor to initialize balance
    public SimpleATM(Decimal initialBalance) {
        balance = initialBalance;
    }
    
    // Method to check current balance
    public Decimal checkBalance() {
        return balance;
    }

    // Method to deposit money
    public void deposit(Decimal amount) {
        if (amount > 0) {
            balance += amount;
        } else {
            System.debug('Deposit amount must be greater than 0.');
        }
    }

    // Method to withdraw money
    public void withdraw(Decimal amount) {
        if (amount <= 0) {
            System.debug('Withdrawal amount must be greater than 0.');
        } else if (amount > balance) {
            System.debug('Insufficient funds.');
        } else {
            balance -= amount;
        }
    }
}