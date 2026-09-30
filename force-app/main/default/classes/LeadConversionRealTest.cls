@Is{!Environment.IvanTest}(SeeAllData=true)
public class LeadConversionReal{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void convertRealLead() {
        Map<String, String> result = LeadConversionExecutor.execute('{!Environment.IvanTest}_Lead_1938123');

        System.assertNotEquals(null, result.get('status'), 'Status should not be null');
        System.assertNotEquals('ERROR', result.get('status'),
            'Conversion error: ' + result.get('message'));

        for (String key : result.keySet()) {
            System.debug('CONVERSION_RESULT [' + key + ']: ' + result.get(key));
        }

        String status = result.get('status');
        System.assert(
            status == 'CONVERTED' || status == 'ALREADY_CONVERTED' || status == 'NOT_FOUND',
            'Unexpected status: ' + status + ' | Message: ' + result.get('message')
        );
    }
}