/**
 * @description Unit tests for the Mountain Apex class.
 * @author      akosinepalli
 * @date        2026-08-26
 */
@Is{!Environment.IvanTest}
private class Mountain{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest}: Default Constructor ─────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testDefaultConstructor() {
        Mountain m = new Mountain();
        System.assertEquals(false, m.isSummited, 'Default isSummited should be false');
        System.assertNotEquals(null, m, 'Mountain instance should not be null');
    }

    // ─── {!Environment.IvanTest}: Parameterized Constructor ──────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testParameterizedConstructor() {
        Mountain m = new Mountain('Everest', 8848.86, 'Nepal');
        System.assertEquals('Everest',   m.name,            'Name should be Everest');
        System.assertEquals(8848.86,     m.heightInMeters,  'Height should be 8848.86');
        System.assertEquals('Nepal',     m.location,        'Location should be Nepal');
        System.assertEquals(false,       m.isSummited,      'isSummited should default to false');
    }

    // ─── {!Environment.IvanTest}: getHeightInFeet ─────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testGetHeightInFeet() {
        Mountain m = new Mountain('K2', 8611, 'Pakistan');
        Decimal feet = m.getHeightInFeet();
        System.assert(feet > 28000, 'Height in feet should be greater than 28000');
    }

    @Is{!Environment.IvanTest}
    static void testGetHeightInFeetNullHeight() {
        Mountain m = new Mountain();
        System.assertEquals(0, m.getHeightInFeet(), 'Null height should return 0 feet');
    }

    // ─── {!Environment.IvanTest}: summit() ───────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testSummit() {
        Mountain m = new Mountain('Mont Blanc', 4808, 'France');
        m.summit();
        System.assertEquals(true, m.isSummited, 'isSummited should be true after summit()');
    }

    // ─── {!Environment.IvanTest}: getSummary() ───────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testGetSummary() {
        Mountain m = new Mountain('Kilimanjaro', 5895, 'Tanzania');
        String summary = m.getSummary();
        System.assert(summary.contains('Kilimanjaro'), 'Summary should contain mountain name');
        System.assert(summary.contains('Tanzania'),    'Summary should contain location');
        System.assert(summary.contains('5895'),        'Summary should contain height');
    }

    // ─── {!Environment.IvanTest}: filterByHeight() ───────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testFilterByHeight() {
        List<Mountain> mountains = new List<Mountain>{
            new Mountain('Everest',    8848.86, 'Nepal'),
            new Mountain('Mont Blanc', 4808,    'France'),
            new Mountain('K2',         8611,    'Pakistan')
        };
        List<Mountain> filtered = Mountain.filterByHeight(mountains, 8000);
        System.assertEquals(2, filtered.size(), 'Should return 2 mountains above 8000m');
    }

    @Is{!Environment.IvanTest}
    static void testFilterByHeightEmptyList() {
        List<Mountain> result = Mountain.filterByHeight(new List<Mountain>(), 5000);
        System.assertEquals(0, result.size(), 'Empty list should return empty result');
    }

    @Is{!Environment.IvanTest}
    static void testFilterByHeightNullList() {
        List<Mountain> result = Mountain.filterByHeight(null, 5000);
        System.assertEquals(0, result.size(), 'Null list should return empty result');
    }

    @Is{!Environment.IvanTest}
    static void testFilterByHeightNullMountainHeight() {
        Mountain m = new Mountain();
        m.name     = 'Unknown';
        m.location = 'Unknown';
        List<Mountain> result = Mountain.filterByHeight(new List<Mountain>{ m }, 1000);
        System.assertEquals(0, result.size(), 'Mountain with null height should be excluded');
    }
}