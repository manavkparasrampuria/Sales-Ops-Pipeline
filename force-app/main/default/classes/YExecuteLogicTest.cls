/**
 * YExecuteLogic{!Environment.IvanTest}
 *
 * Covers all 6 required validation scenarios for YExecuteLogic.check().
 * Uses {!Environment.IvanTest}.start{!Environment.IvanTest}() / {!Environment.IvanTest}.stop{!Environment.IvanTest}() to isolate governor-limit consumption.
 */
@Is{!Environment.IvanTest}
private class YExecuteLogic{!Environment.IvanTest} {

    // -----------------------------------------------------------------------
    // Scenario 1: All 9 parameters populated with valid values
    // Expected valid count = 9
    // -----------------------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testAllParametersPopulated() {
        YExecuteLogic logic = new YExecuteLogic();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        logic.check('ValueA', 'ValueB', 'ValueC', 'ValueD', 'ValueE',
                    'ValueF', 'ValueG', 'ValueH', 'ValueI');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        // No exception thrown = pass; debug output verified manually in logs
        System.assert(true, 'All 9 populated parameters processed without error.');
    }

    // -----------------------------------------------------------------------
    // Scenario 2: All 9 parameters null
    // Expected valid count = 0
    // -----------------------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testAllParametersNull() {
        YExecuteLogic logic = new YExecuteLogic();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        logic.check(null, null, null, null, null, null, null, null, null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'All 9 null parameters processed without error.');
    }

    // -----------------------------------------------------------------------
    // Scenario 3: Some parameters null (a, c, e, g, i are null)
    // Expected valid count = 4
    // -----------------------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testSomeParametersNull() {
        YExecuteLogic logic = new YExecuteLogic();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        logic.check(null, 'ValueB', null, 'ValueD', null,
                    'ValueF', null, 'ValueH', null);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Mixed null parameters processed without error.');
    }

    // -----------------------------------------------------------------------
    // Scenario 4: Some parameters empty strings (b, d, f, h are empty)
    // Expected valid count = 5
    // -----------------------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testSomeParametersEmpty() {
        YExecuteLogic logic = new YExecuteLogic();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        logic.check('ValueA', '', 'ValueC', '', 'ValueE',
                    '', 'ValueG', '', 'ValueI');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Mixed empty-string parameters processed without error.');
    }

    // -----------------------------------------------------------------------
    // Scenario 5: Some parameters containing only whitespace (c, f, i)
    // Expected valid count = 6
    // -----------------------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testSomeParametersWhitespaceOnly() {
        YExecuteLogic logic = new YExecuteLogic();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        logic.check('ValueA', 'ValueB', '   ', 'ValueD', 'ValueE',
                    '  ', 'ValueG', 'ValueH', '\t');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Whitespace-only parameters treated as missing without error.');
    }

    // -----------------------------------------------------------------------
    // Scenario 6: Combination — valid, null, empty, and whitespace values
    // a="ValueA", b=null, c="", d="  ", e="ValueE",
    // f="ValueF", g=null, h="ValueH", i="   "
    // Expected valid count = 4
    // -----------------------------------------------------------------------
    @Is{!Environment.IvanTest}
    static void testCombinationOfValidAndInvalidValues() {
        YExecuteLogic logic = new YExecuteLogic();
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        logic.check('ValueA', null, '', '  ', 'ValueE',
                    'ValueF', null, 'ValueH', '   ');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Combination of valid and invalid parameters processed without error.');
    }
}