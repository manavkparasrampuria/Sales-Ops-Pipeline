/**
 * @class       sagarApex7709{!Environment.IvanTest}
 * @description Unit tests for sagarApex7709 utility class.
 *              Targets >= 75% code coverage per org standards.
 * @author      Copado Build Agent
 * @date        2026-09-08
 */
@Is{!Environment.IvanTest}
private class sagarApex7709{!Environment.IvanTest} {

    // ─── Arithmetic {!Environment.IvanTest}s ─────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testAdd() {
        Integer result = sagarApex7709.add(5, 3);
        Assert.areEqual(8, result, 'Expected 5 + 3 = 8');
    }

    @Is{!Environment.IvanTest}
    static void testSubtract() {
        Integer result = sagarApex7709.subtract(10, 4);
        Assert.areEqual(6, result, 'Expected 10 - 4 = 6');
    }

    @Is{!Environment.IvanTest}
    static void testMultiply() {
        Integer result = sagarApex7709.multiply(6, 7);
        Assert.areEqual(42, result, 'Expected 6 * 7 = 42');
    }

    // ─── String Helper {!Environment.IvanTest}s ──────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testIsBlank_withBlankString() {
        Assert.isTrue(sagarApex7709.isBlank(''), 'Empty string should be blank');
    }

    @Is{!Environment.IvanTest}
    static void testIsBlank_withNullString() {
        Assert.isTrue(sagarApex7709.isBlank(null), 'Null should be blank');
    }

    @Is{!Environment.IvanTest}
    static void testIsBlank_withNonBlankString() {
        Assert.isFalse(sagarApex7709.isBlank('hello'), 'Non-empty string should not be blank');
    }

    @Is{!Environment.IvanTest}
    static void testToTitleCase_normalInput() {
        String result = sagarApex7709.toTitleCase('hello world');
        Assert.areEqual('Hello World', result, 'Expected title-cased output');
    }

    @Is{!Environment.IvanTest}
    static void testToTitleCase_blankInput() {
        String result = sagarApex7709.toTitleCase('');
        Assert.areEqual('', result, 'Blank input should return empty string');
    }

    @Is{!Environment.IvanTest}
    static void testToTitleCase_nullInput() {
        String result = sagarApex7709.toTitleCase(null);
        Assert.areEqual('', result, 'Null input should return empty string');
    }

    // ─── Result Factory {!Environment.IvanTest}s ─────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testBuildSuccess() {
        sagarApex7709.Result res = sagarApex7709.buildSuccess('All good', 42);
        Assert.isTrue(res.success, 'Success flag should be true');
        Assert.areEqual('All good', res.message, 'Message should match');
        Assert.areEqual(42, res.data, 'Data payload should match');
    }

    @Is{!Environment.IvanTest}
    static void testBuildError() {
        sagarApex7709.Result res = sagarApex7709.buildError('Something went wrong');
        Assert.isFalse(res.success, 'Success flag should be false');
        Assert.areEqual('Something went wrong', res.message, 'Error message should match');
        Assert.isNull(res.data, 'Data should be null on error');
    }
}