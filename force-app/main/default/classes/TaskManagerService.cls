/**
 * @description Service class for managing Task records in a bulkified,
 *              reusable manner. Follows the "with sharing" pattern and
 *              delegates trigger logic to prevent recursion.
 */
public with sharing class TaskManagerService {

    // Prevent recursive trigger execution
    private static Boolean isRunning = false;

    /**
     * @description Creates a list of Task records for a given set of WhatId references.
     * @param whatIds       Set of SObject IDs to associate tasks with.
     * @param subject       Subject line for each Task.
     * @param dueDate       Due date for each Task.
     * @param priority      Priority value (e.g. 'High', 'Normal', 'Low').
     * @return              List of inserted Task records.
     */
    public static List<Task> createTasksForRecords(
        Set<Id> whatIds,
        String subject,
        Date dueDate,
        String priority
    ) {
        if (whatIds == null || whatIds.isEmpty()) {
            return new List<Task>();
        }

        List<Task> tasksToInsert = new List<Task>();
        for (Id whatId : whatIds) {
            tasksToInsert.add(new Task(
                Subject      = subject,
                WhatId       = whatId,
                ActivityDate = dueDate,
                Priority     = priority,
                Status       = 'Not Started'
            ));
        }

        insert tasksToInsert;
        return tasksToInsert;
    }

    /**
     * @description Closes (marks Complete) all open Tasks for the given WhatIds.
     * @param whatIds   Set of SObject IDs whose open Tasks should be closed.
     */
    public static void closeOpenTasksForRecords(Set<Id> whatIds) {
        if (whatIds == null || whatIds.isEmpty()) {
            return;
        }

        List<Task> openTasks = [
            SELECT Id, Status
            FROM   Task
            WHERE  WhatId IN :whatIds
            AND    Status != 'Completed'
            WITH USER_MODE
        ];

        if (openTasks.isEmpty()) {
            return;
        }

        for (Task t : openTasks) {
            t.Status = 'Completed';
        }

        update openTasks;
    }

    /**
     * @description Returns all Tasks associated with the given WhatIds,
     *              ordered by ActivityDate ascending.
     * @param whatIds   Set of SObject IDs to query Tasks for.
     * @return          List of Task records.
     */
    public static List<Task> getTasksForRecords(Set<Id> whatIds) {
        if (whatIds == null || whatIds.isEmpty()) {
            return new List<Task>();
        }

        return [
            SELECT Id, Subject, Status, Priority, ActivityDate, WhatId
            FROM   Task
            WHERE  WhatId IN :whatIds
            WITH USER_MODE
            ORDER BY ActivityDate ASC NULLS LAST
        ];
    }

    /**
     * @description Guard method used by trigger handlers to prevent recursion.
     * @return  True if the service is already executing; false otherwise.
     */
    public static Boolean isAlreadyRunning() {
        return isRunning;
    }

    /**
     * @description Sets the running flag. Call with true at the start of a
     *              trigger handler and false at the end.
     * @param value Boolean flag value.
     */
    public static void setRunning(Boolean value) {
        isRunning = value;
    }
}