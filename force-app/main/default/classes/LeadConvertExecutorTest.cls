@is{!Environment.IvanTest}
public class LeadConvertExecutor{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void testExecute() {
        Lead testLead = new Lead(
            FirstName = 'Copado {!Environment.IvanTest}',
            LastName = 'Lead',
            Company = 'Copado {!Environment.IvanTest} Company',
            Email = 'copado.exec.test@example.com',
            Phone = '5551112222'
        );
        insert testLead;
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        LeadConvertExecutor.execute();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}