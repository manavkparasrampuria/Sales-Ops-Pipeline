/**
 * LeadHandler{!Environment.IvanTest}.cls
 * {!Environment.IvanTest} class with INTENTIONALLY LOW coverage (less than 80%)
 */
@is{!Environment.IvanTest}
public class LeadHandler{!Environment.IvanTest} {
    
    @is{!Environment.IvanTest}
    static void testProcessLeadsOnly() {
        // Create minimal test data
        Lead testLead = new Lead(
            FirstName = '{!Environment.IvanTest}',
            LastName = 'Lead',
            Company = '{!Environment.IvanTest} Company',
            Email = 'test@example.com'
        );
        insert testLead;
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        
        // Only test ONE method - this gives ~50% coverage
        LeadHandler.processLeads(new List<Lead>{testLead});
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        // Minimal assertion
        Lead updatedLead = [SELECT Id, Description FROM Lead WHERE Id = :testLead.Id];
        System.assertNotEquals(null, updatedLead);
    }
    
    // NOTE: We are NOT testing the updateLeads method
    // This results in coverage around 50% (well below 80%)
}