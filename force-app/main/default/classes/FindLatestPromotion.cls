@is{!Environment.IvanTest}(SeeAllData=true)
public class FindLatestPromotion {
    @is{!Environment.IvanTest}
    static void findPromo() {
        List<copado__Org__c> allOrgs = [
            SELECT Id, Name, copado__Environment__c, copado__Environment__r.Name
            FROM copado__Org__c
            WHERE copado__Environment__c IN ('a0eJ3000005KEdKIAW', 'a0eJ3000005KEd0IAG')
        ];
        System.debug('Total orgs found: ' + allOrgs.size());
        for (copado__Org__c o : allOrgs) {
            System.debug('@@ORG@@' + o.Id + '|' + o.Name + '|' + o.copado__Environment__c + '|' + o.copado__Environment__r.Name);
        }

        Id srcOrgId = null;
        Id dstOrgId = null;
        for (copado__Org__c o : allOrgs) {
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
            System.debug('@@CREATED_PROMO@@' + promo.Id);

            copado__Promoted_User_Story__c pus = new copado__Promoted_User_Story__c();
            pus.copado__Promotion__c = promo.Id;
            pus.copado__User_Story__c = 'a26If000000GqdeIAC';
            insert pus;
            System.debug('@@CREATED_PUS@@' + pus.Id);
        } else {
            System.debug('@@NO_ORGS_FOUND@@');
        }

        List<copado__Promotion__c> promos = [
            SELECT Id, Name, CreatedDate, copado__Status__c
            FROM copado__Promotion__c
            WHERE copado__Project__c = 'a1AJ3000000M59YMAS'
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
        System.debug('Total promotions: ' + promos.size());
        for (copado__Promotion__c p : promos) {
            System.debug('@@PROMO@@' + p.Id + '|' + p.Name + '|' + p.copado__Status__c);
        }
        System.assert(true);
    }
}