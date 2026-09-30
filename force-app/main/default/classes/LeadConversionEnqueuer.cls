public class LeadConversionEnqueuer {
    public static String enqueue() {
        String jobId = System.enqueueJob(new LeadConversionQueueable());
        System.debug('ENQUEUED_JOB_ID: ' + jobId);
        return jobId;
    }
}