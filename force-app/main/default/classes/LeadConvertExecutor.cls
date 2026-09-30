public class LeadConvertExecutor {
    public static void execute() {
        Map<String, Object> result = LeadConvertCopado.findAndConvertLead();
        System.debug('FINAL_CONVERSION_RESULT: ' + JSON.serialize(result));
    }
}