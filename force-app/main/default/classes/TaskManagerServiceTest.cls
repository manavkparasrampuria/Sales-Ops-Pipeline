/**
 * @description {!Environment.IvanTest} class for TaskManagerService.
 *              Covers positive, negative, and bulk scenarios.
 */
@Is{!Environment.IvanTest}
private class TaskManagerService{!Environment.IvanTest} {

    // ─── {!Environment.IvanTest} Data Setup ────────────────────────────────────────────────────

    @{!Environment.IvanTest}Setup
    static void setupData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = '{!Environment.IvanTest} Account ' + i));
        }
        insert accounts;
    }

    // ─── Positive {!Environment.IvanTest}s ──────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testCreateTasksForRecords_positive() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 5];
        Set<Id> whatIds = new Map<Id, Account>(accounts).keySet();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Task> created = TaskManagerService.createTasksForRecords(
            whatIds, 'Follow Up', Date.today().addDays(7), 'High'
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(5, created.size(), 'Should create one Task per Account');
        for (Task t : created) {
            System.assertEquals('Follow Up',   t.Subject,  'Subject should match');
            System.assertEquals('High',        t.Priority, 'Priority should match');
            System.assertEquals('Not Started', t.Status,   'Status should be Not Started');
        }
    }

    @Is{!Environment.IvanTest}
    static void testGetTasksForRecords_positive() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 3];
        Set<Id> whatIds = new Map<Id, Account>(accounts).keySet();

        TaskManagerService.createTasksForRecords(
            whatIds, 'Initial Task', Date.today(), 'Normal'
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Task> fetched = TaskManagerService.getTasksForRecords(whatIds);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(3, fetched.size(), 'Should retrieve all inserted Tasks');
    }

    @Is{!Environment.IvanTest}
    static void testCloseOpenTasksForRecords_positive() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 3];
        Set<Id> whatIds = new Map<Id, Account>(accounts).keySet();

        TaskManagerService.createTasksForRecords(
            whatIds, 'Task to Close', Date.today(), 'Low'
        );

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        TaskManagerService.closeOpenTasksForRecords(whatIds);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<Task> closedTasks = [
            SELECT Id, Status FROM Task WHERE WhatId IN :whatIds
        ];
        for (Task t : closedTasks) {
            System.assertEquals('Completed', t.Status, 'All tasks should be Completed');
        }
    }

    // ─── Negative {!Environment.IvanTest}s ──────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testCreateTasksForRecords_nullInput() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Task> result = TaskManagerService.createTasksForRecords(
            null, 'Subject', Date.today(), 'Normal'
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(0, result.size(), 'Null input should return empty list');
    }

    @Is{!Environment.IvanTest}
    static void testCreateTasksForRecords_emptyInput() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Task> result = TaskManagerService.createTasksForRecords(
            new Set<Id>(), 'Subject', Date.today(), 'Normal'
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(0, result.size(), 'Empty input should return empty list');
    }

    @Is{!Environment.IvanTest}
    static void testGetTasksForRecords_emptyInput() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Task> result = TaskManagerService.getTasksForRecords(new Set<Id>());
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(0, result.size(), 'Empty input should return empty list');
    }

    @Is{!Environment.IvanTest}
    static void testCloseOpenTasksForRecords_noOpenTasks() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 2];
        Set<Id> whatIds = new Map<Id, Account>(accounts).keySet();

        TaskManagerService.createTasksForRecords(
            whatIds, 'Already Done', Date.today(), 'Normal'
        );
        TaskManagerService.closeOpenTasksForRecords(whatIds);

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        TaskManagerService.closeOpenTasksForRecords(whatIds);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assert(true, 'No exception should be thrown when no open tasks exist');
    }

    // ─── Bulk {!Environment.IvanTest}s ──────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testCreateTasksForRecords_bulk() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 200];
        Set<Id> whatIds = new Map<Id, Account>(accounts).keySet();

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Task> created = TaskManagerService.createTasksForRecords(
            whatIds, 'Bulk Task', Date.today().addDays(30), 'Normal'
        );
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(200, created.size(), 'Should handle 200 records in bulk');
    }

    // ─── Recursion Guard {!Environment.IvanTest}s ────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testRecursionGuard() {
        System.assertEquals(false, TaskManagerService.isAlreadyRunning(),
            'Guard should be false by default');

        TaskManagerService.setRunning(true);
        System.assertEquals(true, TaskManagerService.isAlreadyRunning(),
            'Guard should be true after setting');

        TaskManagerService.setRunning(false);
        System.assertEquals(false, TaskManagerService.isAlreadyRunning(),
            'Guard should reset to false');
    }
}