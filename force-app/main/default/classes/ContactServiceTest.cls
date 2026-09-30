@is{!Environment.IvanTest}
private class ContactService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account');
        insert acc;

        List<Contact> contacts = new List<Contact>{
            new Contact(
                FirstName = 'Web',
                LastName = 'Lead',
                Email = 'weblead@test.com',
                AccountId = acc.Id,
                LeadSource = 'Web'
            ),
            new Contact(
                FirstName = 'Other',
                LastName = 'Lead',
                Email = 'otherlead@test.com',
                AccountId = acc.Id,
                LeadSource = 'Phone'
            )
        };
        insert contacts;
    }

    @is{!Environment.IvanTest}
    static void testGetContactStatus_WebLead() {
        Contact con = [SELECT Id FROM Contact WHERE LeadSource = 'Web' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = ContactService.getContactStatus(con.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Web Lead', result, 'Expected Web Lead status for LeadSource = Web');
    }

    @is{!Environment.IvanTest}
    static void testGetContactStatus_OtherLead() {
        Contact con = [SELECT Id FROM Contact WHERE LeadSource = 'Phone' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        String result = ContactService.getContactStatus(con.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Other Lead', result, 'Expected Other Lead status for LeadSource != Web');
    }
}