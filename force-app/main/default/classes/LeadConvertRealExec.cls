public class LeadConvertRealExec {
    public static String executeConversion() {
        Map<String, Object> result = LeadConvertCopado.findAndConvertLead();
        String json = JSON.serialize(result);
        System.debug('REAL_CONVERSION_RESULT: ' + json);
        return json;
    }
}