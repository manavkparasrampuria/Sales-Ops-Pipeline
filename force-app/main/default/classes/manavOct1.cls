/**
 * @description Example class for the Agentia local flow.
 *              Finds open Cases and escalates them in bulk.
 */
public with sharing class manavOct1 {

    public static final String ESCALATED_STATUS = 'Escalated';

    public manavOct1() {
        // Intentionally empty. All logic is in static methods.
    }

    /**
     * @description Returns Cases that are not closed.
     * @param maxRecords Maximum number of records to return (1 to 200).
     * @return List of open Cases.
     */
    public static List<Case> getOpenCases(Integer maxRecords) {
        Integer limitValue = (maxRecords == null || maxRecords < 1 || maxRecords > 200)
            ? 200
            : maxRecords;

        return [
            SELECT Id, CaseNumber, Subject, Status, Priority
            FROM Case
            WHERE IsClosed = false
            WITH USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT :limitValue
        ];
    }

    /**
     * @description Sets the Priority to High on the given Cases in one DML statement.
     * @param caseIds Ids of the Cases to update.
     * @return Number of Cases updated.
     */
    public static Integer markCasesHighPriority(Set<Id> caseIds) {
        if (caseIds == null || caseIds.isEmpty()) {
            return 0;
        }

        List<Case> casesToUpdate = new List<Case>();
        for (Case c : [
            SELECT Id, Priority
            FROM Case
            WHERE Id IN :caseIds AND IsClosed = false
            WITH USER_MODE
        ]) {
            c.Priority = 'High';
            casesToUpdate.add(c);
        }

        if (!casesToUpdate.isEmpty()) {
            Database.update(casesToUpdate, AccessLevel.USER_MODE);
        }
        return casesToUpdate.size();
    }
}