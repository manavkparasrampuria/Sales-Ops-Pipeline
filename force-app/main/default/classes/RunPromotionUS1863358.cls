public class RunPromotionUS1863358 {
    public static String run() {
        // Create the promotion record
        copado__Promotion__c promo = new copado__Promotion__c();
        promo.copado__Source_Environment__c = 'a0eJ3000005KEdKIAW';
        promo.copado__Destination_Environment__c = 'a0eJ3000005KEd0IAG';
        promo.copado__Project__c = 'a1AJ3000000M59YMAS';
        promo.copado__Back_Promotion__c = false;
        promo.copado__Source_Org_Credential__c = 'a15J3000000CJXiIAO';
        promo.copado__Destination_Org_Credential__c = 'a15J3000000CJXOIA4';
        promo.copado__Status__c = 'Draft';
        insert promo;

        // Link the user story to the promotion
        copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
        pus.copado__Promotion__c = promo.Id;
        pus.copado__User_Story__c = 'a26If000000GqdKIAS';
        insert pus;

        System.debug('Promotion ID: ' + promo.Id);
        return promo.Id;
    }
}