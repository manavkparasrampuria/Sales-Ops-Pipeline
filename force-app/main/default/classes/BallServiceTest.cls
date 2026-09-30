@is{!Environment.IvanTest}
private class BallService{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        List<Ball__c> balls = new List<Ball__c>{
            new Ball__c(Name = 'Football'),
            new Ball__c(Name = 'Basketball'),
            new Ball__c(Name = 'Tennis Ball')
        };
        insert balls;
    }

    // ─── POSITIVE TESTS ───────────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testCreateBall_positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Ball__c result = BallService.createBall('Cricket Ball');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, result.Id, 'Ball should have been inserted and have an Id.');
        Ball__c fetched = [SELECT Name FROM Ball__c WHERE Id = :result.Id];
        System.assertEquals('Cricket Ball', fetched.Name, 'Ball name should match.');
    }

    @is{!Environment.IvanTest}
    static void testCreateBalls_bulk_positive() {
        List<String> names = new List<String>();
        for (Integer i = 1; i <= 200; i++) {
            names.add('Ball ' + i);
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Ball__c> results = BallService.createBalls(names);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(200, results.size(), 'Should have created 200 Ball records.');
    }

    @is{!Environment.IvanTest}
    static void testGetBallById_positive() {
        Ball__c existing = [SELECT Id FROM Ball__c WHERE Name = 'Football' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Ball__c result = BallService.getBallById(existing.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals('Football', result.Name, 'Should return the correct Ball record.');
    }

    @is{!Environment.IvanTest}
    static void testGetAllBalls_positive() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Ball__c> results = BallService.getAllBalls();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(results.size() >= 3, 'Should return at least 3 Ball records from setup.');
    }

    @is{!Environment.IvanTest}
    static void testUpdateBallName_positive() {
        Ball__c existing = [SELECT Id FROM Ball__c WHERE Name = 'Basketball' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Ball__c updated = BallService.updateBallName(existing.Id, 'Volleyball');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Ball__c fetched = [SELECT Name FROM Ball__c WHERE Id = :existing.Id];
        System.assertEquals('Volleyball', fetched.Name, 'Ball name should have been updated.');
    }

    @is{!Environment.IvanTest}
    static void testDeleteBall_positive() {
        Ball__c existing = [SELECT Id FROM Ball__c WHERE Name = 'Tennis Ball' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        BallService.deleteBall(existing.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Ball__c> remaining = [SELECT Id FROM Ball__c WHERE Id = :existing.Id];
        System.assertEquals(0, remaining.size(), 'Ball record should have been deleted.');
    }

    @is{!Environment.IvanTest}
    static void testDeleteBalls_bulk_positive() {
        List<Ball__c> existing = [SELECT Id FROM Ball__c];
        List<Id> ids = new List<Id>();
        for (Ball__c b : existing) {
            ids.add(b.Id);
        }

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        BallService.deleteBalls(ids);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Ball__c> remaining = [SELECT Id FROM Ball__c WHERE Id IN :ids];
        System.assertEquals(0, remaining.size(), 'All Ball records should have been deleted.');
    }

    // ─── NEGATIVE TESTS ───────────────────────────────────────────────

    @is{!Environment.IvanTest}
    static void testCreateBall_blankName_negative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.createBall('');
            System.assert(false, 'Exception should have been thrown for blank name.');
        } catch (BallService.BallServiceException e) {
            System.assertEquals('Ball name cannot be blank.', e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testCreateBalls_emptyList_negative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.createBalls(new List<String>());
            System.assert(false, 'Exception should have been thrown for empty list.');
        } catch (BallService.BallServiceException e) {
            System.assertEquals('Names list cannot be null or empty.', e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testGetBallById_nullId_negative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.getBallById(null);
            System.assert(false, 'Exception should have been thrown for null Id.');
        } catch (BallService.BallServiceException e) {
            System.assertEquals('Ball Id cannot be null.', e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testGetBallById_notFound_negative() {
        // Use a fake but valid-format Id
        Id fakeId = '000000000000000AAA';
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.getBallById(fakeId);
            System.assert(false, 'Exception should have been thrown for non-existent Id.');
        } catch (BallService.BallServiceException e) {
            System.assert(e.getMessage().contains('No Ball__c record found'), 'Unexpected message: ' + e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testUpdateBallName_blankName_negative() {
        Ball__c existing = [SELECT Id FROM Ball__c WHERE Name = 'Football' LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.updateBallName(existing.Id, '   ');
            System.assert(false, 'Exception should have been thrown for blank new name.');
        } catch (BallService.BallServiceException e) {
            System.assertEquals('New name cannot be blank.', e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testDeleteBall_nullId_negative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.deleteBall(null);
            System.assert(false, 'Exception should have been thrown for null Id.');
        } catch (BallService.BallServiceException e) {
            System.assertEquals('Ball Id cannot be null.', e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @is{!Environment.IvanTest}
    static void testDeleteBalls_emptyList_negative() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            BallService.deleteBalls(new List<Id>());
            System.assert(false, 'Exception should have been thrown for empty list.');
        } catch (BallService.BallServiceException e) {
            System.assertEquals('Ball Ids list cannot be null or empty.', e.getMessage());
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}