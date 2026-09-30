public class CreatePromotionUS1864358 {
    public static Map<String, String> run() {
        Map<String, String> result = new Map<String, String>();

        Id userStoryId = 'a26If000000GqpVIAS';

        copado__User_Story__c us = [
            SELECT Id, Name, copado__Environment__c, copado__Org_Credential__c,
                   copado__Project__c, copado__Status__c
            FROM copado__User_Story__c
            WHERE Id = :userStoryId
            LIMIT 1
        ];

        copado__Deployment_Flow_Step__c conn = [
            SELECT Id, copado__Source_Environment__c, copado__Destination_Environment__c,
                   copado__Destination_Branch__c, copado__Deployment_Flow__c
            FROM copado__Deployment_Flow_Step__c
            WHERE copado__Source_Environment__c = :us.copado__Environment__c
            AND copado__Deployment_Flow__c = 'a0YJ30000047S7yMAE'
            LIMIT 1
        ];

        copado__Org__c destCred = [
            SELECT Id, Name
            FROM copado__Org__c
            WHERE copado__Environment__c = :conn.copado__Destination_Environment__c
            LIMIT 1
        ];

        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Source_Environment__c = us.copado__Environment__c;
        promo.copado__Destination_Environment__c = conn.copado__Destination_Environment__c;
        promo.copado__Source_Org_Credential__c = us.copado__Org_Credential__c;
        promo.copado__Destination_Org_Credential__c = destCred.Id;
        promo.copado__Status__c = 'Draft';
        insert promo;

        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__User_Story__c = userStoryId;
        pus.copado__Promotion__c = promo.Id;
        insert pus;

        String promoName = [SELECT Name FROM copado__Promotion__c WHERE Id = :promo.Id].Name;
        result.put('promotionId', promo.Id);
        result.put('promotionName', promoName);
        result.put('sourceEnvironment', us.copado__Environment__c);
        result.put('destinationEnvironment', conn.copado__Destination_Environment__c);

        System.debug('PROMOTION_CREATED: ' + JSON.serialize(result));
        return result;
    }
}