public class CreatePromotionForUS1864146 {
    public static Map<String, String> createAndExecutePromotion() {
        Map<String, String> result = new Map<String, String>();
        
        // User Story ID for US-0000425 ({!Environment.IvanTest} User Story_1864146)
        Id userStoryId = 'a26If000000GqkLIAS';
        
        // Query the user story to get environment
        copado__User_Story__c us = [
            SELECT Id, Name, copado__Environment__c, copado__Org_Credential__c,
                   copado__Project__c, copado__Status__c
            FROM copado__User_Story__c
            WHERE Id = :userStoryId
            LIMIT 1
        ];
        
        // Find the pipeline connection from AIdev1 to AIStaging
        copado__Deployment_Flow_Step__c conn = [
            SELECT Id, copado__Source_Environment__c, copado__Destination_Environment__c,
                   copado__Destination_Branch__c,
                   copado__Deployment_Flow__c
            FROM copado__Deployment_Flow_Step__c
            WHERE copado__Source_Environment__c = :us.copado__Environment__c
            AND copado__Deployment_Flow__c = 'a0YJ30000047S7yMAE'
            LIMIT 1
        ];
        
        // Find destination credential
        copado__Org__c destCred = [
            SELECT Id, Name
            FROM copado__Org__c
            WHERE copado__Environment__c = :conn.copado__Destination_Environment__c
            LIMIT 1
        ];
        
        // Create the Promotion record
        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Source_Environment__c = us.copado__Environment__c;
        promo.copado__Destination_Environment__c = conn.copado__Destination_Environment__c;
        promo.copado__Source_Org_Credential__c = us.copado__Org_Credential__c;
        promo.copado__Destination_Org_Credential__c = destCred.Id;
        promo.copado__Status__c = 'Draft';
        insert promo;
        
        // Add user story to promotion
        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__User_Story__c = userStoryId;
        pus.copado__Promotion__c = promo.Id;
        insert pus;
        
        result.put('promotionId', promo.Id);
        result.put('destinationEnv', conn.copado__Destination_Environment__c);
        result.put('destBranch', conn.copado__Destination_Branch__c);
        result.put('destCredential', destCred.Id);
        
        return result;
    }
}