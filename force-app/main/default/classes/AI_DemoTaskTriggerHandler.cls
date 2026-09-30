public with sharing class AI_DemoTaskTriggerHandler {
    private static final Decimal DEFAULT_RATE = 50;

    public static void setDefaultRate(List<AI_Demo_Task__c> newTasks) {
        for (AI_Demo_Task__c task : newTasks) {
            if (task.Rate__c == null) {
                task.Rate__c = DEFAULT_RATE;
            }
        }
    }
}