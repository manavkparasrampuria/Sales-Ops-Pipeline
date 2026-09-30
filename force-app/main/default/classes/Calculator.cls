public class Calculator {
    
    // Method to add two numbers
    public Integer add(Integer num1, Integer num2) {
        return num1 + num2;
    }
    
    // Method to subtract two numbers
    public Integer subtract(Integer num1, Integer num2) {
        return num1 - num2;
    }
    
    // Method to multiply two numbers
    public Integer multiply(Integer num1, Integer num2) {
        return num1 * num2;
    }
    
    // Method to divide two numbers
    public Double divide(Integer num1, Integer num2) {
        if (num2 == 0) {
            throw new IllegalArgumentException('Cannot divide by zero');
        }
        return Double.valueOf(num1) / Double.valueOf(num2);
    }
    
    // Method to calculate the factorial of a number
    public Integer factorial(Integer num) {
        if (num < 0) {
            throw new IllegalArgumentException('Number must be non-negative');
        }
        if (num == 0) {
            return 1;
        }
        Integer result = 1;
        for (Integer i = 1; i <= num; i++) {
            result *= i;
        }
        return result;
    }
    
    // Method to find the maximum of two numbers
    public Integer max(Integer num1, Integer num2) {
        return num1 > num2 ? num1 : num2;
    }
    
    // Method to find the minimum of two numbers
    public Integer min(Integer num1, Integer num2) {
        return num1 < num2 ? num1 : num2;
    }
}