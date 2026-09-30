/**
 * @class       sagarApex724944{!Environment.IvanTest}
 * @description Unit tests for sagarApex724944 utility class.
 *              Targets >= 75% code coverage per org standards.
 * @author      Copado Build Agent
 * @date        2026-09-09
 */
@Is{!Environment.IvanTest}
private class sagarApex724944{!Environment.IvanTest} {

    // --- Arithmetic {!Environment.IvanTest}s ----------------------------------------------------

    @Is{!Environment.IvanTest}
    static void testAdd() {
        Integer result = sagarApex724944.add(5, 3);
        Assert.areEqual(8, result, 'Expected 5 + 3 = 8');
    }

    @Is{!Environment.IvanTest}
    static void testSubtract() {
        Integer result = sagarApex724944.subtract(10, 4);
        Assert.areEqual(6, result, 'Expected 10 - 4 = 6');
    }

    @Is{!Environment.IvanTest}
    static void testMultiply() {
        Integer result = sagarApex724944.multiply(6, 7);
        Assert.areEqual(42, result, 'Expected 6 * 7 = 42');
    }

    // --- String Helper {!Environment.IvanTest}s -------------------------------------------------

    @Is{!Environment.IvanTest}
    static void testIsBlank_withBlankString() {
        Assert.isTrue(sagarApex724944.isBlank(''), 'Empty string should be blank');
    }

    @Is{!Environment.IvanTest}
    static void testIsBlank_withNullString() {
        Assert.isTrue(sagarApex724944.isBlank(null), 'Null should be blank');
    }

    @Is{!Environment.IvanTest}
    static void testIsBlank_withNonBlankString() {
        Assert.isFalse(sagarApex724944.isBlank('hello'), 'Non-empty string should not be blank');
    }

    @Is{!Environment.IvanTest}
    static void testToTitleCase_normalInput() {
        String result = sagarApex724944.toTitleCase('hello world');
        Assert.areEqual('Hello World', result, 'Expected title-cased output');
    }

    @Is{!Environment.IvanTest}
    static void testToTitleCase_blankInput() {
        String result = sagarApex724944.toTitleCase('');
        Assert.areEqual('', result, 'Blank input should return empty string');
    }

    @Is{!Environment.IvanTest}
    static void testToTitleCase_nullInput() {
        String result = sagarApex724944.toTitleCase(null);
        Assert.areEqual('', result, 'Null input should return empty string');
    }

    // --- Result Factory {!Environment.IvanTest}s ------------------------------------------------

    @Is{!Environment.IvanTest}
    static void testBuildSuccess() {
        sagarApex724944.Result res = sagarApex724944.buildSuccess('All good', 42);
        Assert.isTrue(res.success, 'Success flag should be true');
        Assert.areEqual('All good', res.message, 'Message should match');
        Assert.areEqual(42, res.data, 'Data payload should match');
    }

    @Is{!Environment.IvanTest}
    static void testBuildError() {
        sagarApex724944.Result res = sagarApex724944.buildError('Something went wrong');
        Assert.isFalse(res.success, 'Success flag should be false');
        Assert.areEqual('Something went wrong', res.message, 'Error message should match');
        Assert.isNull(res.data, 'Data should be null on error');
    }
}