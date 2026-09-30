@is{!Environment.IvanTest}(SeeAllData=true)
public class CreatePromotionUS1914990{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testCreatePromotion() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = CreatePromotionUS1914990.createPromotion();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('|'), 'Result should contain promotion and PUS IDs');
        System.debug('@@RESULT@@' + result);
    }
}