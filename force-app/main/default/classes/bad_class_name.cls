/*
 * PMD Violation {!Environment.IvanTest} Class
 * This class intentionally violates numerous PMD rules for testing purposes.
 * It lacks a sharing declaration, uses the global modifier unnecessarily, and has a terrible name.
 */
global class bad_class_name { 

    // DESIGN & STYLE: Excessive public variables, bad naming conventions
    public String ID1 = '001x00000000001AAA'; // SECURITY: Hardcoded ID
    public String ID2 = '001x00000000002AAA'; // SECURITY: Hardcoded ID
    public String ID3 = '001x00000000003AAA'; // SECURITY: Hardcoded ID
    public Integer A_bad_name = 1;
    public Integer B_bad_name = 2;
    public Integer C_bad_name = 3;
    public Integer D_bad_name = 4;
    public Integer E_bad_name = 5;
    public Integer F_bad_name = 6;
    public Integer G_bad_name = 7;
    public Integer H_bad_name = 8;
    public Integer I_bad_name = 9;
    public Integer J_bad_name = 10;

    // ERROR PRONE: Method with the same name as the enclosing class
    public void bad_class_name() {
        System.debug('This looks like a constructor but is not.');
    }

    // DESIGN & STYLE: Excessive parameters, bad method naming
    public void Do_Terrible_Things(Integer p1, Integer p2, Integer p3, Integer p4, Integer p5, Integer p6, Integer p7) {
        
        // ERROR PRONE: Empty if statements
        if (p1 == 1) {
        }
        if (p2 == 2) {
        }
        if (p3 == 3) {
        }

        // ERROR PRONE: Missing braces for control structures
        if (p4 == 4) System.debug('No braces here');
        for(Integer i=0; i<5; i++) System.debug('No braces in this loop');

        // DESIGN: Deeply nested if statements
        if (p1 == 1) {
            if (p2 == 2) {
                if (p3 == 3) {
                    if (p4 == 4) {
                        if (p5 == 5) {
                            System.debug('This nesting is far too deep.');
                        }
                    }
                }
            }
        }

        // PERFORMANCE: SOQL and DML inside loops
        for (Integer i = 0; i < 10; i++) {
            List<Account> accs = [SELECT Id, Name FROM Account LIMIT 1]; 
            Account a = new Account(Name='{!Environment.IvanTest} ' + i);
            insert a; 
            update a; 
            delete a; 
        }
    }

    // SECURITY: SOQL Injection vulnerability
    public List<Contact> getContacts(String userInput) {
        String query = 'SELECT Id, LastName FROM Contact WHERE LastName = \'' + userInput + '\'';
        return Database.query(query); 
    }

    // SECURITY: Open Redirect vulnerability
    public PageReference redirectToBadUrl(String urlParam) {
        PageReference pageRef = new PageReference(urlParam); 
        return pageRef;
    }

    // ERROR PRONE: Empty catch block
    public void another_bad_method() {
        try {
            Integer x = 1 / 0;
        } catch (Exception e) {
            
        }
    }
    
    // PERFORMANCE: More SOQL in loops to inflate violation count
    public void more_loop_issues() {
        for (Integer j = 0; j < 50; j++) {
            List<Contact> cons = [SELECT Id FROM Contact LIMIT 1];
            System.debug(cons);
        }
    }
}