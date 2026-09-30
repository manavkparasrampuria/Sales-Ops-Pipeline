@is{!Environment.IvanTest}
private class Convert{!Environment.IvanTest}Lead1908669{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testNoLeadFound() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, Object> result = Convert{!Environment.IvanTest}Lead1908669.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assertEquals('error', (String) result.get('status'));
        System.assert(((String) result.get('message')).contains('No Lead found'));
    }

    @is{!Environment.IvanTest}
    static void testSuccessfulConversion() {
        Account acc = new Account(
            Name = '{!Environment.IvanTest} Company 1908669',
            Phone = '5550001908',
            Bypass__c = true
        );
        insert acc;

        Lead testLead = new Lead(
            LastName = '{!Environment.IvanTest}_Lead_1908669',
            Company = '{!Environment.IvanTest} Company 1908669',
            Email = 'testlead1908669@example.com'
        );
        insert testLead;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, Object> result = Convert{!Environment.IvanTest}Lead1908669.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('success', (String) result.get('status'), 'Conversion should succeed: ' + result.get('message'));
        System.assertNotEquals(null, result.get('opportunity_id'));
        System.assertNotEquals(null, result.get('contact_id'));
        System.assertEquals(acc.Id, (Id) result.get('account_id'));
    }

    @is{!Environment.IvanTest}
    static void testAlreadyConverted() {
        Account acc = new Account(
            Name = '{!Environment.IvanTest} Company 1908669',
            Phone = '5550001908',
            Bypass__c = true
        );
        insert acc;

        Lead testLead = new Lead(
            LastName = '{!Environment.IvanTest}_Lead_1908669',
            Company = '{!Environment.IvanTest} Company 1908669',
            Email = 'testlead1908669@example.com'
        );
        insert testLead;

        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        lc.setAccountId(acc.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(true);
        Database.convertLead(lc);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Map<String, Object> result = Convert{!Environment.IvanTest}Lead1908669.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('already_converted', (String) result.get('status'));
    }
}