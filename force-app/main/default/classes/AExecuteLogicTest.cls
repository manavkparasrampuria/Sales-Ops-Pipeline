@Is{!Environment.IvanTest}
private class AExecuteLogic{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testRunLogic_returnsExpectedSummary() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = AExecuteLogic.runLogic('val1', 'val2', 'val3', 'val4', 'val5', 'val6');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('val1'), 'Result should contain val1');
        System.assert(result.contains('val6'), 'Result should contain val6');
    }

    @Is{!Environment.IvanTest}
    static void testRunLogic_withEmptyStrings() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = AExecuteLogic.runLogic('', '', '', '', '', '');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result, 'Result should not be null even with empty strings');
    }
}