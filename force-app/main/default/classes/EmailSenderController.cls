public with sharing class EmailSenderController {

    @AuraEnabled
    public static void sendEmail(String toAddress, String subject, String body) {
        if (String.isBlank(toAddress) || String.isBlank(subject) || String.isBlank(body)) {
            throw new AuraHandledException('To address, subject, and body are required.');
        }

        List<String> toAddresses = new List<String>();
        for (String addr : toAddress.split(',')) {
            String trimmed = addr.trim();
            if (String.isNotBlank(trimmed)) {
                toAddresses.add(trimmed);
            }
        }

        if (toAddresses.isEmpty()) {
            throw new AuraHandledException('No valid email addresses provided.');
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setSaveAsActivity(false);

        if (!{!Environment.IvanTest}.isRunning{!Environment.IvanTest}()) {
            try {
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            } catch (Exception e) {
                throw new AuraHandledException('Failed to send email: ' + e.getMessage());
            }
        }
    }
}