@is{!Environment.IvanTest}(SeeAllData=true)
public class GetPromoIdUS412 {
    @is{!Environment.IvanTest}
    static void getPromoId() {
        List<copado__Promoted_User_Story__c> puss = [
            SELECT Id, copado__Promotion__c, copado__Promotion__r.Name,
                   copado__Promotion__r.copado__Status__c, copado__Promotion__r.CreatedDate
            FROM copado__Promoted_User_Story__c
            WHERE copado__User_Story__c = 'a26If000000GqehIAC'
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
        for (copado__Promoted_User_Story__c pus : puss) {
            System.debug('@@RESULT@@promoId=' + pus.copado__Promotion__c + '|promoName=' + pus.copado__Promotion__r.Name + '|status=' + pus.copado__Promotion__r.copado__Status__c + '|created=' + pus.copado__Promotion__r.CreatedDate);
        }
        System.assert(true);
    }
}