// Example Post Deployment Script
public class DeploymentStepScript {
    
    public static void runDeploymentStep() {
        // Example: Ensure a default Account record exists after deployment
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Default Account' LIMIT 1];
        
        if (acc == null) {
            acc = new Account(Name = 'Default Account');
            insert acc;
            System.debug('✅ Default Account created.');
        } else {
            System.debug('ℹ️ Default Account already exists.');
        }
    }
}