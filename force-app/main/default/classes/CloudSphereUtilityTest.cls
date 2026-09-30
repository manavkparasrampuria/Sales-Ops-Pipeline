/**
 * @description Unit tests for CloudSphereUtility.
 * @author      Copado Build Agent
 * @date        2026-09-28
 */
@Is{!Environment.IvanTest}
private class CloudSphereUtility{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testIsBlank() {
        System.assertEquals(true,  CloudSphereUtility.isBlank(null),  'Null should be blank');
        System.assertEquals(true,  CloudSphereUtility.isBlank(''),    'Empty string should be blank');
        System.assertEquals(true,  CloudSphereUtility.isBlank('   '), 'Whitespace should be blank');
        System.assertEquals(false, CloudSphereUtility.isBlank('abc'), 'Non-empty string should not be blank');
    }

    @Is{!Environment.IvanTest}
    static void testCapitalize() {
        System.assertEquals('Hello',  CloudSphereUtility.capitalize('hello'),  'Should capitalize first letter');
        System.assertEquals('World',  CloudSphereUtility.capitalize('WORLD'),  'Should lowercase the rest');
        System.assertEquals(null,     CloudSphereUtility.capitalize(null),     'Null input should return null');
        System.assertEquals(null,     CloudSphereUtility.capitalize(''),       'Blank input should return null');
    }

    @Is{!Environment.IvanTest}
    static void testGetTodayFormatted() {
        String result = CloudSphereUtility.getTodayFormatted();
        System.assertNotEquals(null, result, 'Today formatted should not be null');
        System.assertEquals(10, result.length(), 'Date string should be 10 characters (YYYY-MM-DD)');
    }

    @Is{!Environment.IvanTest}
    static void testDaysBetween() {
        Date start = Date.newInstance(2026, 1, 1);
        Date endDt = Date.newInstance(2026, 1, 11);
        System.assertEquals(10, CloudSphereUtility.daysBetween(start, endDt), 'Should be 10 days apart');
        System.assertEquals(null, CloudSphereUtility.daysBetween(null, endDt), 'Null start should return null');
        System.assertEquals(null, CloudSphereUtility.daysBetween(start, null), 'Null end should return null');
    }

    @Is{!Environment.IvanTest}
    static void testMax() {
        System.assertEquals(10, CloudSphereUtility.max(5, 10),  'Should return the larger value');
        System.assertEquals(10, CloudSphereUtility.max(10, 5),  'Should return the larger value');
        System.assertEquals(5,  CloudSphereUtility.max(5, 5),   'Equal values should return the same');
    }

    @Is{!Environment.IvanTest}
    static void testMin() {
        System.assertEquals(5,  CloudSphereUtility.min(5, 10),  'Should return the smaller value');
        System.assertEquals(5,  CloudSphereUtility.min(10, 5),  'Should return the smaller value');
        System.assertEquals(5,  CloudSphereUtility.min(5, 5),   'Equal values should return the same');
    }
}