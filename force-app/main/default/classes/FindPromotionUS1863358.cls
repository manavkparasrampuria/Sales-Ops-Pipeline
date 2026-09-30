public class FindPromotionUS1863358 {
    @AuraEnabled
    public static String findPromotion() {
        List<copado__Promoted_User_Story__c> pusRecords = [
            SELECT Id, copado__Promotion__c, copado__Promotion__r.Name, copado__Promotion__r.copado__Status__c,
                   copado__Promotion__r.CreatedDate
            FROM copado__Promoted_User_Story__c
            WHERE copado__User_Story__c = 'a26If000000GqdKIAS'
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
        String result = '';
        for (copado__Promoted_User_Story__c pus : pusRecords) {
            result += pus.copado__Promotion__c + '|' + pus.copado__Promotion__r.Name + '|' + pus.copado__Promotion__r.copado__Status__c + '\n';
        }
        System.debug('Promotions for US: ' + result);
        return result;
    }
}