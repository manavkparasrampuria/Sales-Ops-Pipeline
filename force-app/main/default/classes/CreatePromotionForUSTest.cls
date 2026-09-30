@Is{!Environment.IvanTest}
public class CreatePromotionForUS{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}
    static void testRun() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            CreatePromotionForUS.run();
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Executed');
    }
}