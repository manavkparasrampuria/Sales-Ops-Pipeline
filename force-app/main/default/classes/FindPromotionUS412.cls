@is{!Environment.IvanTest}(SeeAllData=true)
public class FindPromotionUS412 {
    @is{!Environment.IvanTest}
    static void findPromo() {
        List<copado__Promotion__c> promos = [
            SELECT Id, Name, CreatedDate, copado__Status__c,
                   copado__Source_Environment__r.Name, copado__Destination_Environment__r.Name
            FROM copado__Promotion__c
            WHERE copado__Project__c = 'a1AJ3000000M59YMAS'
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
        for (copado__Promotion__c p : promos) {
            System.debug('@@PROMO@@' + p.Id + '|' + p.Name + '|' + p.copado__Status__c + '|src=' + p.copado__Source_Environment__r.Name + '|dst=' + p.copado__Destination_Environment__r.Name + '|created=' + p.CreatedDate);
        }

        // Also check promoted user stories for our US
        List<copado__Promoted_User_Story__c> puss = [
            SELECT Id, copado__Promotion__c, copado__User_Story__c, CreatedDate
            FROM copado__Promoted_User_Story__c
            WHERE copado__User_Story__c = 'a26If000000GqehIAC'
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
        for (copado__Promoted_User_Story__c pus : puss) {
            System.debug('@@PUS@@' + pus.Id + '|promo=' + pus.copado__Promotion__c + '|us=' + pus.copado__User_Story__c);
        }
        System.assert(true);
    }
}