@Is{!Environment.IvanTest}
public class LeadConversionExecutor{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setup() {
        Lead testLead = new Lead(
            FirstName = '{!Environment.IvanTest}',
            LastName = 'Lead_1938123',
            Company = '{!Environment.IvanTest} Company 1938123',
            Email = 'test_lead_1938123@example.com',
            Status = 'Open - Not Contacted'
        );
        insert testLead;
    }

    @Is{!Environment.IvanTest}
    static void testExecuteConversion() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, String> result = LeadConversionExecutor.execute('{!Environment.IvanTest} Lead_1938123');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result);
        System.assertEquals('CONVERTED', result.get('status'));
    }

    @Is{!Environment.IvanTest}
    static void testAlreadyConverted() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead_1938123' LIMIT 1];
        List<LeadStatus> convertedStatuses = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        String convertedStatus = convertedStatuses.isEmpty() ? 'Closed - Converted' : convertedStatuses[0].MasterLabel;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setConvertedStatus(convertedStatus);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName('{!Environment.IvanTest} Opp');
        Database.convertLead(lc);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, String> result = LeadConversionExecutor.execute('{!Environment.IvanTest} Lead_1938123');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('ALREADY_CONVERTED', result.get('status'));
    }

    @Is{!Environment.IvanTest}
    static void testLeadNotFound() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, String> result = LeadConversionExecutor.execute('NonExistentLead_XYZ_999');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('NOT_FOUND', result.get('status'));
    }
}