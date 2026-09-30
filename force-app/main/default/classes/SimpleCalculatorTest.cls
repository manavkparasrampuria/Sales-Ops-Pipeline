@Is{!Environment.IvanTest}
public class SimpleCalculator{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testAdd() {
        Integer result = SimpleCalculator.add(3, 7);
        Assert.areEqual(10, result, 'Expected 3 + 7 to equal 10');
    }

    @Is{!Environment.IvanTest}
    static void testSubtract() {
        Integer result = SimpleCalculator.subtract(10, 4);
        Assert.areEqual(6, result, 'Expected 10 - 4 to equal 6');
    }
}