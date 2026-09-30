@is{!Environment.IvanTest}
private class CommunityFeedbackController{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testSubmitFeedbackSuccess() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        Id feedbackId = CommunityFeedbackController.submitFeedback('Great Community', 'Loving the experience', 5);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertNotEquals(null, feedbackId, 'Feedback record should be created');
        Community_Feedback__c fb = [SELECT Subject__c, Rating__c, Community_User__c FROM Community_Feedback__c WHERE Id = :feedbackId];
        System.assertEquals('Great Community', fb.Subject__c, 'Subject should match input');
        System.assertEquals(5, fb.Rating__c, 'Rating should match input');
        System.assertEquals(UserInfo.getUserId(), fb.Community_User__c, 'Community user should be current user');
    }

    @is{!Environment.IvanTest}
    static void testSubmitFeedbackMissingSubjectThrows() {
        Boolean exceptionThrown = false;
        try {
            CommunityFeedbackController.submitFeedback('', 'No subject provided', 3);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Should throw exception when subject is missing');
    }

    @is{!Environment.IvanTest}
    static void testGetMyFeedbackReturnsOwnRecords() {
        Community_Feedback__c fb = new Community_Feedback__c(
            Subject__c = 'My Feedback',
            Rating__c = 4,
            Community_User__c = UserInfo.getUserId()
        );
        insert fb;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Community_Feedback__c> results = CommunityFeedbackController.getMyFeedback();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(!results.isEmpty(), 'Should return at least one feedback record for current user');
    }
}