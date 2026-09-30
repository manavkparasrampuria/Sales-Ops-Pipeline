public class MultiplicationExample {

    // Method to multiply two numbers
    public static Integer multiplyNumbers(Integer num1, Integer num2) {
        return num1 * num2;
    }

    // {!Environment.IvanTest} method
    public static void testMultiplication() {
        Integer result = multiplyNumbers(10, 5);
        System.debug('Multiplication Result: ' + result); // Output: 50
    }
}