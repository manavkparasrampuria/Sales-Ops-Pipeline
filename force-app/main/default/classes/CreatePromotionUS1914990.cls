public class CreatePromotionUS1914990 {
    public static String createPromotion() {
        String projectId = 'a1AJ3000000M59YMAS';
        String userStoryId = 'a26If000000GyesIAC';
        String sourceEnvId = 'a0eJ3000005KEdKIAW';

        copado__Environment__c destEnv = [
            SELECT Id, Name
            FROM copado__Environment__c
            WHERE Name = 'AIStaging'
            LIMIT 1
        ];

        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Project__c = projectId;
        promo.copado__Source_Environment__c = sourceEnvId;
        promo.copado__Destination_Environment__c = destEnv.Id;
        promo.copado__Status__c = 'Draft';
        insert promo;

        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__User_Story__c = userStoryId;
        pus.copado__Promotion__c = promo.Id;
        insert pus;

        copado__Promotion__c createdPromo = [
            SELECT Id, Name
            FROM copado__Promotion__c
            WHERE Id = :promo.Id
            LIMIT 1
        ];

        return createdPromo.Id + '|' + createdPromo.Name + '|' + destEnv.Id + '|' + pus.Id;
    }
}