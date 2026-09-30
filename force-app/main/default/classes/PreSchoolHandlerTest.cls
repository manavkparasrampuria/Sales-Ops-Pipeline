/**
 * @description Unit tests for PreSchoolHandler and PreSchoolTrigger.
 *              Covers: default values, validation, welcome task creation,
 *              status change logging, bulk operations.
 * @author      Copado Orchestrate Agent
 * @date        2026-09-18
 */
@Is{!Environment.IvanTest}
private class PreSchoolHandler{!Environment.IvanTest} {

    // ─── Helper ───────────────────────────────────────────────────────────────

    private static PreSchool__c buildSchool(String name, String email) {
        return new PreSchool__c(
            Name                = name,
            Contact_Email__c    = email,
            Maximum_Capacity__c = 30
        );
    }

    // ─── Insert {!Environment.IvanTest}s ─────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testInsert_setsDefaultStatus() {
        PreSchool__c school = new PreSchool__c(
            Name                = 'Sunshine PreSchool',
            Contact_Email__c    = 'sunshine@test.com',
            Maximum_Capacity__c = 25
        );
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert school;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        PreSchool__c result = [
            SELECT Status__c, Enrollment_Date__c
            FROM PreSchool__c WHERE Id = :school.Id
        ];
        System.assertEquals('Active', result.Status__c,
            'Default status should be Active.');
        System.assertEquals(Date.today(), result.Enrollment_Date__c,
            'Default enrollment date should be today.');
    }

    @Is{!Environment.IvanTest}
    static void testInsert_createsWelcomeTask() {
        PreSchool__c school = buildSchool('Rainbow PreSchool', 'rainbow@test.com');
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert school;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Task> tasks = [SELECT Subject FROM Task WHERE WhatId = :school.Id];
        System.assertEquals(1, tasks.size(), 'One welcome task should be created.');
        System.assert(
            tasks[0].Subject.contains('Rainbow PreSchool'),
            'Task subject should reference the school name.'
        );
    }

    @Is{!Environment.IvanTest}
    static void testInsert_missingEmail_throwsError() {
        PreSchool__c school = new PreSchool__c(Name = 'No Email School');
        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert school;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(
                e.getMessage().contains('Contact Email'),
                'Error message should mention Contact Email.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(exceptionThrown, 'DmlException expected for missing Email.');
    }

    @Is{!Environment.IvanTest}
    static void testInsert_invalidCapacity_throwsError() {
        PreSchool__c school = new PreSchool__c(
            Name                = 'Bad Capacity School',
            Contact_Email__c    = 'bad@test.com',
            Maximum_Capacity__c = -5
        );
        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            insert school;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(
                e.getMessage().contains('Maximum Capacity'),
                'Error message should mention Maximum Capacity.'
            );
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(exceptionThrown, 'DmlException expected for negative capacity.');
    }

    // ─── Update {!Environment.IvanTest}s ─────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testUpdate_statusChangeToInactive() {
        PreSchool__c school = buildSchool('Star PreSchool', 'star@test.com');
        insert school;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        school.Status__c = 'Inactive';
        update school;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        PreSchool__c result = [SELECT Status__c FROM PreSchool__c WHERE Id = :school.Id];
        System.assertEquals('Inactive', result.Status__c,
            'Status should be updated to Inactive.');
    }

    @Is{!Environment.IvanTest}
    static void testUpdate_missingEmail_throwsError() {
        PreSchool__c school = buildSchool('Moon PreSchool', 'moon@test.com');
        insert school;

        Boolean exceptionThrown = false;
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            school.Contact_Email__c = null;
            update school;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(exceptionThrown, 'DmlException expected for null email on update.');
    }

    // ─── Bulk {!Environment.IvanTest} ────────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testBulkInsert_200Records() {
        List<PreSchool__c> schools = new List<PreSchool__c>();
        for (Integer i = 0; i < 200; i++) {
            schools.add(buildSchool('School ' + i, 'school' + i + '@test.com'));
        }
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        insert schools;
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Id> schoolIds = new List<Id>();
        for (PreSchool__c s : schools) {
            schoolIds.add(s.Id);
        }

        Integer count = [SELECT COUNT() FROM PreSchool__c WHERE Id IN :schoolIds];
        System.assertEquals(200, count, '200 PreSchool records should be inserted.');

        Integer taskCount = [SELECT COUNT() FROM Task WHERE WhatId IN :schoolIds];
        System.assertEquals(200, taskCount, '200 welcome tasks should be created.');
    }
}