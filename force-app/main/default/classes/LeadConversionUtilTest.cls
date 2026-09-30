@Is{!Environment.IvanTest}
public class LeadConversionUtil{!Environment.IvanTest} {

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
    static void testConvertLead() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        LeadConversionUtil.ConversionResult result = LeadConversionUtil.convertLead('{!Environment.IvanTest} Lead_1938123');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @Is{!Environment.IvanTest}
    static void testLeadNotFound() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        LeadConversionUtil.ConversionResult result = LeadConversionUtil.convertLead('NonExistentLead_XYZ');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Lead not found: NonExistentLead_XYZ', result.message);
    }
}