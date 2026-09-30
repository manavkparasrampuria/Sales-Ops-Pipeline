/**
 * LeadHandler.cls
 * Sales Operations - Lead Management Enhancement
 * 
 * This class contains ONLY Priority-1 violations that PMD will definitely catch
 */
public class LeadHandler {
    
    // PRIORITY-1 VIOLATION: OperationWithLimitsInLoop - SOQL in loop (GUARANTEED Priority-1)
    public static void processLeads(List<Lead> leads) {
        for(Lead l : leads) {
            // This SOQL in loop is a GUARANTEED Priority-1 violation
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = :l.Company LIMIT 1];
            
            if(accounts.size() > 0) {
                l.Description = 'Account found: ' + accounts[0].Id;
            }
        }
    }
    
    // PRIORITY-1 VIOLATION: AvoidDmlStatementsInLoops - DML in loop (GUARANTEED Priority-1)
    public static void updateLeads(List<Lead> leads) {
        for(Lead l : leads) {
            if(l.Rating == null) {
                l.Rating = 'Cold';
                // This DML in loop is a GUARANTEED Priority-1 violation
                update l;
            }
        }
    }
}