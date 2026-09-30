public class CreatePromotionUS407 {
    public static void run() {
        copado.CreatePromotions.InvocableVariables vars = new copado.CreatePromotions.InvocableVariables();
        vars.backPromotion = false;
        vars.sourceEnvironmentId = 'a0eJ3000005KEdKIAW';
        vars.destinationEnvironmentId = 'a0eJ3000005KEd0IAG';
        vars.projectId = 'a1AJ3000000M59YMAS';

        List<copado.CreatePromotions.InvocableVariables> varsList = new List<copado.CreatePromotions.InvocableVariables>{ vars };
        List<SObject> promotionResults = copado.CreatePromotions.execute(varsList);

        if (promotionResults != null && !promotionResults.isEmpty()) {
            SObject promotion = promotionResults[0];
            Id promotionId = (Id) promotion.get('Id');
            System.debug('Promotion created: ' + promotionId);

            copado.CreatePromotedUserStories.InvocableVariables pusVars = new copado.CreatePromotedUserStories.InvocableVariables();
            pusVars.promotionId = promotionId;
            pusVars.userStoryIds = new List<Id>{ 'a26If000000GqdeIAC' };

            List<copado.CreatePromotedUserStories.InvocableVariables> pusVarsList = new List<copado.CreatePromotedUserStories.InvocableVariables>{ pusVars };
            List<SObject> pusResults = copado.CreatePromotedUserStories.execute(pusVarsList);
            System.debug('Promoted User Stories: ' + pusResults);
            System.debug('PROMOTION_ID:' + promotionId);
        }
    }
}