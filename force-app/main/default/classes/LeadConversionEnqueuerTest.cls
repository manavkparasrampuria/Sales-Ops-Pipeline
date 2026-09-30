// SeeAllData=true so the real Lead is visible; the enqueued job runs
// after the test transaction commits and its DML persists in the org.
@is{!Environment.IvanTest}(SeeAllData=true)
public class LeadConversionEnqueuer{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void enqueueRealConversion() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String jobId = LeadConversionEnqueuer.enqueue();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertNotEquals(null, jobId, 'A job ID should be returned');
    }
}