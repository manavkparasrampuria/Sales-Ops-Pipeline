@is{!Environment.IvanTest}(SeeAllData=true)
public class LeadConvertRealExec{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testRealLeadConversion() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String jsonResult = LeadConvertRealExec.executeConversion();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        System.assertNotEquals(null, jsonResult, 'Result JSON should not be null');
        System.debug('CAPTURED_RESULT: ' + jsonResult);
        
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        System.assert(result.containsKey('conversion_status'), 'Must have conversion_status');
        System.assert(result.containsKey('lead_name'), 'Must have lead_name');
    }
}