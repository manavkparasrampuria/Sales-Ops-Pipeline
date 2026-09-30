@is{!Environment.IvanTest}
public class LeadConvertCopado{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testFindAndConvertLead() {
        Lead testLead = new Lead(
            FirstName = 'Copado {!Environment.IvanTest}',
            LastName = 'Lead',
            Company = 'Copado {!Environment.IvanTest} Company',
            Email = 'copado.test.lead@example.com',
            Phone = '5551234567'
        );
        insert testLead;
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, Object> result = LeadConvertCopado.findAndConvertLead();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.containsKey('conversion_status'), 'Result must have conversion_status');
        System.assertEquals('success', result.get('conversion_status'), 'Conversion should succeed');
        System.debug('TEST_RESULT: ' + JSON.serialize(result));
    }
    
    @is{!Environment.IvanTest}
    static void testLeadNotFound() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, Object> result = LeadConvertCopado.findAndConvertLead();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        System.assertEquals('error', result.get('conversion_status'));
        System.assertEquals('', result.get('lead_id'));
    }
    
    @is{!Environment.IvanTest}
    static void testAlreadyConvertedLead() {
        Lead testLead = new Lead(
            FirstName = 'Copado {!Environment.IvanTest}',
            LastName = 'Lead',
            Company = 'Copado {!Environment.IvanTest} Company',
            Email = 'copado.test.lead2@example.com',
            Phone = '5559876543'
        );
        insert testLead;
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        lc.setDoNotCreateOpportunity(true);
        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.convertLead(lc);
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, Object> result = LeadConvertCopado.findAndConvertLead();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        System.assertNotEquals(null, result);
        System.assertEquals('error', result.get('conversion_status'), 'Already converted lead should return error');
        System.debug('ALREADY_CONVERTED_RESULT: ' + JSON.serialize(result));
    }
}