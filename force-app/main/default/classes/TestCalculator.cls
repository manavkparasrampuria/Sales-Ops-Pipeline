public with sharing class {!Environment.IvanTest}Calculator {
    // This is the ONLY method we will test
    public Integer add(Integer a, Integer b) {
        return a + b;
    }

    // --- EVERYTHING BELOW WILL BE UNCOVERED (0%) ---
    public Integer subtract(Integer a, Integer b) {
        return a - b;
    }

    public Integer multiply(Integer a, Integer b) {
        return a * b;
    }

    public Decimal divide(Decimal a, Decimal b) {
        if (b == 0) return 0;
        return a / b;
    }

    public Integer power(Integer base, Integer exp) {
        Integer result = 1;
        for (Integer i = 0; i < exp; i++) {
            result *= base;
        }
        return result;
    }
}