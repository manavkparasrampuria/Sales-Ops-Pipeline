public with sharing class RenewalOpportunityBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new RenewalOpportunityBatch(), 200);
    }
    public static String scheduleDaily(String cronExpression) {
        return System.schedule('Renewal Opportunity Daily Batch', cronExpression, new RenewalOpportunityBatchScheduler());
    }
}