@is{!Environment.IvanTest}
private class AIBotService{!Environment.IvanTest} {

    private static User create{!Environment.IvanTest}User() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'AIBot_User' LIMIT 1];
        String uniqueName = 'aibottest' + Math.round(Math.random() * 1000000) + '@testorg.com';
        User u = new User(
            FirstName = 'AIBot',
            LastName = '{!Environment.IvanTest}er',
            Email = uniqueName,
            Username = uniqueName,
            Alias = 'aibott',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert u;
        insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
        return u;
    }

    @{!Environment.IvanTest}Setup
    static void setup() {
        insert new AIBot__c(Name = '{!Environment.IvanTest} Bot', Status__c = 'Training', Bot_Type__c = 'Chatbot');
    }

    @is{!Environment.IvanTest}
    static void testDefaultLastInteractionDateOnInsert() {
        AIBot__c bot = [SELECT Id, Last_Interaction_Date__c FROM AIBot__c LIMIT 1];
        System.assertNotEquals(null, bot.Last_Interaction_Date__c, 'Last Interaction Date should default on insert');
    }

    @is{!Environment.IvanTest}
    static void testGetAIBots() {
        User testUser = create{!Environment.IvanTest}User();
        List<AIBot__c> bots;
        System.runAs(testUser) {
            {!Environment.IvanTest}.start{!Environment.IvanTest}();
            bots = AIBotService.getAIBots();
            {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        }
        System.assert(!bots.isEmpty(), 'Should return at least one AIBot record');
    }

    @is{!Environment.IvanTest}
    static void testUpdateAIBotStatus() {
        User testUser = create{!Environment.IvanTest}User();
        AIBot__c bot = [SELECT Id FROM AIBot__c LIMIT 1];
        System.runAs(testUser) {
            {!Environment.IvanTest}.start{!Environment.IvanTest}();
            AIBotService.updateAIBotStatus(bot.Id, 'Active');
            {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        }
        AIBot__c result = [SELECT Status__c FROM AIBot__c WHERE Id = :bot.Id];
        System.assertEquals('Active', result.Status__c);
    }

    @is{!Environment.IvanTest}
    static void testNotifyTrainingStatus() {
        AIBot__c bot = [SELECT Id FROM AIBot__c LIMIT 1];
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        AIBotService.notifyTrainingStatus(new List<Id>{ bot.Id });
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Invocable method executed without unhandled exception');
    }

    @is{!Environment.IvanTest}
    static void testBulkInsert() {
        List<AIBot__c> bulkBots = new List<AIBot__c>();
        for (Integer i = 0; i < 200; i++) {
            bulkBots.add(new AIBot__c(Name = 'Bulk Bot ' + i, Status__c = 'Inactive', Bot_Type__c = 'Other'));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert bulkBots;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        List<AIBot__c> inserted = [SELECT Id, Last_Interaction_Date__c FROM AIBot__c WHERE Name LIKE 'Bulk Bot%'];
        System.assertEquals(200, inserted.size());
        for (AIBot__c b : inserted) {
            System.assertNotEquals(null, b.Last_Interaction_Date__c);
        }
    }

    @is{!Environment.IvanTest}
    static void testValidationRuleBlocksActiveWithoutBotType() {
        AIBot__c bot = new AIBot__c(Name = 'Invalid Bot', Status__c = 'Active');
        Boolean dmlFailed = false;
        try {
            insert bot;
        } catch (DmlException e) {
            dmlFailed = true;
        }
        System.assert(dmlFailed, 'Validation rule should block Active status without Bot Type');
    }
}