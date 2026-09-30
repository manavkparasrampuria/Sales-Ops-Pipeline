@is{!Environment.IvanTest}
private class QueryLead1908669{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testNotFound() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        QueryLead1908669.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testFound() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Company 1908669', Phone = '5550001908', Bypass__c = true);
        insert acc;
        Lead l = new Lead(LastName = '{!Environment.IvanTest}_Lead_1908669', Company = '{!Environment.IvanTest} Company 1908669', Email = 'tl@example.com');
        insert l;
        LeadStatus cs = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setAccountId(acc.Id);
        lc.setConvertedStatus(cs.MasterLabel);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityName('{!Environment.IvanTest} Opp 1908669');
        Database.convertLead(lc);
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        QueryLead1908669.run();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}