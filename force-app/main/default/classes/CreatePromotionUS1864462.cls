public class CreatePromotionUS1864462 {
    public static Map<String, String> createPromotion() {
        Map<String, String> result = new Map<String, String>();
        
        // Step 1: Get the Project ID
        String projectId = 'a1AJ3000000M59YMAS';
        String userStoryId = 'a26If000000GqrWIAS';
        
        // Step 2: Get the User Story's source environment
        copado__User_Story__c us = [
            SELECT Id, Name, copado__Environment__c, copado__Environment__r.Name
            FROM copado__User_Story__c
            WHERE Id = :userStoryId
            LIMIT 1
        ];
        
        // Step 3: Get the pipeline connection to determine destination environment
        // Source is AIdev1 (a0eJ3000005KEdKIAW), destination is AIStaging (a0eJ3000005KEd0IAG)
        String sourceEnvId = 'a0eJ3000005KEdKIAW';
        String destEnvId = 'a0eJ3000005KEd0IAG';
        
        // Step 4: Create the Promotion record
        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Project__c = projectId;
        promo.copado__Source_Environment__c = sourceEnvId;
        promo.copado__Destination_Environment__c = destEnvId;
        promo.copado__Status__c = 'Draft';
        insert promo;
        
        // Step 5: Create the Promoted User Story junction record
        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__User_Story__c = userStoryId;
        pus.copado__Promotion__c = promo.Id;
        insert pus;
        
        result.put('promotionId', promo.Id);
        result.put('promotionName', promo.Name);
        result.put('sourceEnvironment', 'AIdev1');
        result.put('destinationEnvironment', 'AIStaging');
        result.put('userStoryId', userStoryId);
        result.put('projectId', projectId);
        
        return result;
    }
}