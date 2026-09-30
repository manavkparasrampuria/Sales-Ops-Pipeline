@is{!Environment.IvanTest}
private class LeadConversionScript{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testRunNoLead() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        LeadConversionScript.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testRunConvertsLead() {
        Lead testLead = new Lead(
            LastName = '{!Environment.IvanTest}_Lead_1910334',
            Company  = '{!Environment.IvanTest} Company',
            Phone    = '5550001234',
            Status   = 'New'
        );
        insert testLead;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        LeadConversionScript.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Lead converted = [SELECT IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(converted.IsConverted, 'Lead should be converted');
    }

    @is{!Environment.IvanTest}
    static void testRunAlreadyConverted() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Company', Phone = '5550001234');
        insert acc;

        Lead testLead = new Lead(
            LastName = '{!Environment.IvanTest}_Lead_1910334',
            Company  = '{!Environment.IvanTest} Company',
            Phone    = '5550001234',
            Status   = 'New'
        );
        insert testLead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        lc.setAccountId(acc.Id);
        lc.setConvertedStatus('Qualified');
        lc.setDoNotCreateOpportunity(true);
        Database.convertLead(lc);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        LeadConversionScript.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}