public with sharing class HelloWorld {

    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }

    public static Integer addNumbers(Integer a, Integer b) {
        return a + b;
    }

    public static Boolean isEven(Integer num) {
        return Math.mod(num, 2) == 0;
    }
}