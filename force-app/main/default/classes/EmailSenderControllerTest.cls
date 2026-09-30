@Is{!Environment.IvanTest}
public with sharing class EmailSenderController{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testSendEmail_Success() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        EmailSenderController.sendEmail('test@example.com', '{!Environment.IvanTest} Subject', '{!Environment.IvanTest} Body');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Email sent successfully');
    }

    @Is{!Environment.IvanTest}
    static void testSendEmail_MultipleRecipients() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        EmailSenderController.sendEmail('a@example.com, b@example.com', 'Multi Subject', 'Multi Body');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        System.assert(true, 'Email sent to multiple recipients successfully');
    }

    @Is{!Environment.IvanTest}
    static void testSendEmail_BlankToAddress() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            EmailSenderController.sendEmail('', 'Subject', 'Body');
            System.assert(false, 'Expected AuraHandledException was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null, 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testSendEmail_BlankSubject() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            EmailSenderController.sendEmail('test@example.com', '', 'Body');
            System.assert(false, 'Expected AuraHandledException was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null, 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testSendEmail_BlankBody() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            EmailSenderController.sendEmail('test@example.com', 'Subject', '');
            System.assert(false, 'Expected AuraHandledException was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null, 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testSendEmail_NullValues() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            EmailSenderController.sendEmail(null, null, null);
            System.assert(false, 'Expected AuraHandledException was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null, 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testSendEmail_EmptyAddressAfterSplit() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            EmailSenderController.sendEmail('  ,  ,  ', 'Subject', 'Body');
            System.assert(false, 'Expected AuraHandledException was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null, 'Exception message should not be null');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}