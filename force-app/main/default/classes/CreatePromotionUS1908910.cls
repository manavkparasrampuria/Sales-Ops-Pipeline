public class CreatePromotionUS1908910 {
    public static Map<String, String> createPromotion() {
        Map<String, String> result = new Map<String, String>();

        String projectId = 'a1AJ3000000M59YMAS';
        String userStoryId = 'a26If000000GxdYIAS';
        String sourceEnvId = 'a0eJ3000005KEdKIAW';
        String destEnvId = 'a0eJ3000005KEd0IAG';

        // Create the Promotion record
        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Project__c = projectId;
        promo.copado__Source_Environment__c = sourceEnvId;
        promo.copado__Destination_Environment__c = destEnvId;
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

        // Promotion branch follows the convention: promotion/<PromotionName>
        String promotionBranch = 'promotion/' + createdPromo.Name;

        result.put('promotionId', createdPromo.Id);
        result.put('promotionName', createdPromo.Name);
        result.put('promotionBranch', promotionBranch);

        return result;
    }
}