public class QueryAndDeployPromotionUS1863358 {
    public static String getLatestPromotionId() {
        List<copado__Promotion__c> promos = [
            SELECT Id, Name, copado__Status__c, copado__Source_Environment__c, copado__Destination_Environment__c
            FROM copado__Promotion__c
            WHERE copado__Project__c = 'a1AJ3000000M59YMAS'
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
        String result = '';
        for (copado__Promotion__c p : promos) {
            result += p.Id + '|' + p.Name + '|' + p.copado__Status__c + '\n';
        }
        System.debug('Recent Promotions: ' + result);
        return result;
    }
}