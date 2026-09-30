public with sharing class CaseDashboardController {

    @AuraEnabled(cacheable=true)
    public static Case getCaseDetails(Id caseId) {
        if (caseId == null) {
            throw new AuraHandledException('Case ID cannot be null.');
        }
        List<Case> cases = [
            SELECT CaseNumber, Subject, Status, Priority, Owner.Name
            FROM Case
            WHERE Id = :caseId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        if (cases.isEmpty()) {
            throw new AuraHandledException('No Case found with the provided ID.');
        }
        return cases[0];
    }
}