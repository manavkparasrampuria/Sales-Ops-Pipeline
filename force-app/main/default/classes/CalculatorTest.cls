@Is{!Environment.IvanTest}
public class Calculator{!Environment.IvanTest} {
    
    // {!Environment.IvanTest} method for add()
    @Is{!Environment.IvanTest}
    static void testAdd() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num1 = 10;
        Integer num2 = 5;
        
        // Act
        Integer result = calc.add(num1, num2);
        
        // Assert
        System.assertEquals(15, result, 'Addition method failed');
    }
    
    // {!Environment.IvanTest} method for subtract()
    @Is{!Environment.IvanTest}
    static void testSubtract() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num1 = 10;
        Integer num2 = 5;
        
        // Act
        Integer result = calc.subtract(num1, num2);
        
        // Assert
        System.assertEquals(5, result, 'Subtraction method failed');
    }
    
    // {!Environment.IvanTest} method for multiply()
    @Is{!Environment.IvanTest}
    static void testMultiply() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num1 = 10;
        Integer num2 = 5;
        
        // Act
        Integer result = calc.multiply(num1, num2);
        
        // Assert
        System.assertEquals(50, result, 'Multiplication method failed');
    }
    
    // {!Environment.IvanTest} method for divide()
    @Is{!Environment.IvanTest}
    static void testDivide() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num1 = 10;
        Integer num2 = 5;
        
        // Act
        Double result = calc.divide(num1, num2);
        
        // Assert
        System.assertEquals(2.0, result, 'Division method failed');
    }
    
    // {!Environment.IvanTest} method for factorial()
    @Is{!Environment.IvanTest}
    static void testFactorial() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num = 5;
        
        // Act
        Integer result = calc.factorial(num);
        
        // Assert
        System.assertEquals(120, result, 'Factorial method failed');
    }
    
    // {!Environment.IvanTest} method for max()
    @Is{!Environment.IvanTest}
    static void testMax() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num1 = 10;
        Integer num2 = 5;
        
        // Act
        Integer result = calc.max(num1, num2);
        
        // Assert
        System.assertEquals(10, result, 'Max method failed');
    }
    
    // {!Environment.IvanTest} method for min()
    @Is{!Environment.IvanTest}
    static void testMin() {
        // Arrange
        Calculator calc = new Calculator();
        Integer num1 = 10;
        Integer num2 = 5;
        
        // Act
        Integer result = calc.min(num1, num2);
        
        // Assert
        System.assertEquals(5, result, 'Min method failed');
    }
}