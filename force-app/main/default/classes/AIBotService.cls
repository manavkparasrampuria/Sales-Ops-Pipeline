public with sharing class AIBotService {

    @AuraEnabled(cacheable=true)
    public static List<AIBot__c> getAIBots() {
        return [
            SELECT Id, Name, Status__c, Bot_Type__c, Description__c,
                   Last_Interaction_Date__c, Bot_Age_Days__c, Total_Conversations__c
            FROM AIBot__c
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }

    @AuraEnabled
    public static AIBot__c updateAIBotStatus(Id aiBotId, String newStatus) {
        if (!Schema.sObjectType.AIBot__c.fields.Status__c.isUpdateable()) {
            throw new AuraHandledException(System.Label.AIBot_Error_Message);
        }
        AIBot__c bot = new AIBot__c(Id = aiBotId, Status__c = newStatus);
        try {
            update bot;
        } catch (DmlException e) {
            throw new AuraHandledException(System.Label.AIBot_Error_Message + ': ' + e.getMessage());
        }
        return bot;
    }

    public static void setDefaultLastInteractionDate(List<AIBot__c> newBots) {
        for (AIBot__c bot : newBots) {
            if (bot.Last_Interaction_Date__c == null) {
                bot.Last_Interaction_Date__c = System.now();
            }
        }
    }

    @InvocableMethod(label='Notify AIBot Training Status' description='Sends a notification when an AIBot enters Training status')
    public static void notifyTrainingStatus(List<Id> aiBotIds) {
        if (aiBotIds == null || aiBotIds.isEmpty()) {
            return;
        }
        List<AIBot__c> bots = [SELECT Id, Name, OwnerId FROM AIBot__c WHERE Id IN :aiBotIds];
        Set<Id> ownerIds = new Set<Id>();
        for (AIBot__c bot : bots) {
            ownerIds.add(bot.OwnerId);
        }
        Map<Id, User> owners = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :ownerIds]);
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (AIBot__c bot : bots) {
            User owner = owners.get(bot.OwnerId);
            if (owner != null && owner.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{ owner.Email });
                mail.setSubject('AIBot Entered Training: ' + bot.Name);
                mail.setPlainTextBody(System.Label.AIBot_Help_Text);
                emails.add(mail);
            }
        }
        try {
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
        } catch (Exception e) {
            System.debug('AIBotService.notifyTrainingStatus email error: ' + e.getMessage());
        }
    }
}