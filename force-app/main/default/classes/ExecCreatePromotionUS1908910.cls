public class ExecCreatePromotionUS1908910 {
    public static void run() {
        String projectId = 'a1AJ3000000M59YMAS';
        String userStoryId = 'a26If000000GxdYIAS';
        String sourceEnvId = 'a0eJ3000005KEdKIAW';
        
        // Query destination environment by name to get correct ID
        copado__Environment__c destEnv = [
            SELECT Id, Name
            FROM copado__Environment__c
            WHERE Name = 'AIStaging'
            LIMIT 1
        ];
        
        // Create the Promotion record
        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Project__c = projectId;
        promo.copado__Source_Environment__c = sourceEnvId;
        promo.copado__Destination_Environment__c = destEnv.Id;
        promo.copado__Status__c = 'Draft';
        insert promo;
        
        // Link the user story to the promotion
        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__User_Story__c = userStoryId;
        pus.copado__Promotion__c = promo.Id;
        insert pus;
        
        // Retrieve the promotion with its auto-generated name
        copado__Promotion__c createdPromo = [
            SELECT Id, Name
            FROM copado__Promotion__c
            WHERE Id = :promo.Id
            LIMIT 1
        ];
        
        System.debug('RESULT_promotionId: ' + createdPromo.Id);
        System.debug('RESULT_promotionName: ' + createdPromo.Name);
        System.debug('RESULT_promotionBranch: promotion/' + createdPromo.Name);
        System.debug('RESULT_destEnvId: ' + destEnv.Id);
    }
}