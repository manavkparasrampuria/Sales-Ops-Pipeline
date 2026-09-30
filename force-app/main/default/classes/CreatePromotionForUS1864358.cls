public class CreatePromotionForUS1864358 {
    public static String createPromotion() {
        // Create Promotion record for US_Commit_MetaData_1864358 (a26If000000GqpVIAS)
        // Source: AIdev1 (a0eJ3000005KEdKIAW), Destination: AIStaging (a0eJ3000005KEd0IAG)
        // Project: AI_SFDX_Project (a1AJ3000000M59YMAS)
        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Project__c = 'a1AJ3000000M59YMAS';
        promo.copado__Source_Environment__c = 'a0eJ3000005KEdKIAW';
        promo.copado__Destination_Environment__c = 'a0eJ3000005KEd0IAG';
        promo.copado__Source_Org_Credential__c = 'a15J3000000CJXiIAO';
        promo.copado__Destination_Org_Credential__c = 'a15J3000000CJXOIA4';
        promo.copado__Back_Promotion__c = false;
        insert promo;
        
        // Create Promoted User Story junction record
        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__Promotion__c = promo.Id;
        pus.copado__User_Story__c = 'a26If000000GqpVIAS';
        insert pus;
        
        return promo.Id;
    }
}