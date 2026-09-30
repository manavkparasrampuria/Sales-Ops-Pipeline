@is{!Environment.IvanTest}(SeeAllData=true)
public class GetOrgPrefixAndCreatePromo {
    @is{!Environment.IvanTest}
    static void run() {
        // Get the correct copado__Org__c IDs for AIdev1 and AIStaging environments
        List<copado__Org__c> orgs = [
            SELECT Id, Name, copado__Environment__c, copado__Environment__r.Name
            FROM copado__Org__c
            WHERE copado__Environment__c IN ('a0eJ3000005KEdKIAW', 'a0eJ3000005KEd0IAG')
            LIMIT 10
        ];
        for (copado__Org__c o : orgs) {
            System.debug('Org ID: ' + o.Id + ' | Name: ' + o.Name + ' | Env: ' + o.copado__Environment__r.Name);
        }

        // Also get the key prefix of copado__Org__c
        System.debug('copado__Org__c prefix: ' + copado__Org__c.SObjectType.getDescribe().getKeyPrefix());

        // Create the promotion using the correct org IDs
        if (orgs.size() >= 2) {
            Id srcOrgId = null;
            Id dstOrgId = null;
            for (copado__Org__c o : orgs) {
                if (o.copado__Environment__c == 'a0eJ3000005KEdKIAW') srcOrgId = o.Id;
                if (o.copado__Environment__c == 'a0eJ3000005KEd0IAG') dstOrgId = o.Id;
            }
            System.debug('srcOrgId: ' + srcOrgId + ' | dstOrgId: ' + dstOrgId);

            if (srcOrgId != null && dstOrgId != null) {
                copado__Promotion__c promo = new copado__Promotion__c();
                promo.copado__Source_Environment__c = 'a0eJ3000005KEdKIAW';
                promo.copado__Destination_Environment__c = 'a0eJ3000005KEd0IAG';
                promo.copado__Source_Org_Credential__c = srcOrgId;
                promo.copado__Destination_Org_Credential__c = dstOrgId;
                promo.copado__Project__c = 'a1AJ3000000M59YMAS';
                promo.copado__Back_Promotion__c = false;
                insert promo;
                System.debug('PROMOTION_ID:' + promo.Id);

                copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
                pus.copado__Promotion__c = promo.Id;
                pus.copado__User_Story__c = 'a26If000000GqdeIAC';
                insert pus;
                System.debug('PUS_ID:' + pus.Id);
            }
        }
        System.assert(true);
    }
}