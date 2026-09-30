@is{!Environment.IvanTest}
private class AthleteSelector{!Environment.IvanTest} {

    @testSetup
    static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Athlete',
            LastName = '{!Environment.IvanTest}er',
            Email = 'athlete.tester@example.com',
            Username = 'athlete.tester' + DateTime.now().getTime() + '@example.com.test',
            Alias = 'athtst',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert testUser;

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Athlete_Manager' LIMIT 1];
        insert new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = ps.Id
        );

        List<Athlete__c> athletes = new List<Athlete__c>();
        for (Integer i = 1; i <= 5; i++) {
            athletes.add(new Athlete__c(
                Name = 'Athlete ' + i,
                Ranking__c = i,
                Score__c = i * 20,
                Country__c = 'Country ' + i
            ));
        }
        insert athletes;
    }

    @is{!Environment.IvanTest}
    static void testGetTopAthletes() {
        User testUser = [SELECT Id FROM User WHERE Email = 'athlete.tester@example.com' LIMIT 1];
        List<Athlete__c> results;

        System.runAs(testUser) {
            {!Environment.IvanTest}.start{!Environment.IvanTest}();
            results = AthleteSelector.getTopAthletes();
            {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        }

        System.assertEquals(5, results.size(), 'Should return 5 athletes');
        System.assertEquals(100, results[0].Score__c, 'Highest score should be first');
    }

    @is{!Environment.IvanTest}
    static void testValidationRulePreventsInvalidRanking() {
        Athlete__c invalidAthlete = new Athlete__c(
            Name = 'Invalid Athlete',
            Ranking__c = 0,
            Score__c = 50
        );
        Boolean exceptionThrown = false;
        try {
            insert invalidAthlete;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Validation rule should prevent insert with Ranking <= 0');
    }

    @is{!Environment.IvanTest}
    static void testDefaultCountryFlow() {
        Athlete__c athleteNoCountry = new Athlete__c(
            Name = 'No Country Athlete',
            Ranking__c = 10,
            Score__c = 60
        );
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert athleteNoCountry;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Athlete__c result = [SELECT Country__c FROM Athlete__c WHERE Id = :athleteNoCountry.Id];
        System.assertEquals('Unknown', result.Country__c, 'Flow should default blank country to Unknown');
    }
}