/**
 * @description Unit tests for FileUploadManagerController.
 * @author      Copado Build Agent
 * @date        2026-08-08
 */
@Is{!Environment.IvanTest}
private class FileUploadManagerController{!Environment.IvanTest} {

    @{!Environment.IvanTest}Setup
    static void setupData() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account');
        insert acc;

        ContentVersion cv = new ContentVersion(
            Title           = '{!Environment.IvanTest} File',
            PathOnClient    = '{!Environment.IvanTest}File.pdf',
            VersionData     = Blob.valueOf('{!Environment.IvanTest} file content'),
            IsMajorVersion  = true
        );
        insert cv;

        ContentVersion insertedCv = [
            SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1
        ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = insertedCv.ContentDocumentId,
            LinkedEntityId    = acc.Id,
            ShareType         = 'V',
            Visibility        = 'AllUsers'
        );
        insert cdl;
    }

    @Is{!Environment.IvanTest}
    static void testGetFiles_success() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<FileUploadManagerController.FileWrapper> files =
            FileUploadManagerController.getFiles(acc.Id);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        Assert.areEqual(1, files.size(), 'Expected one file linked to the account.');
        Assert.areEqual('{!Environment.IvanTest} File', files[0].title, 'File title should match.');
    }

    @Is{!Environment.IvanTest}
    static void testGetFiles_nullRecordId() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            FileUploadManagerController.getFiles(null);
            Assert.fail('Expected AuraHandledException for null recordId.');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage() != null, 'Exception message should not be null.');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testDeleteFile_success() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        ContentDocumentLink cdl = [
            SELECT ContentDocumentId FROM ContentDocumentLink
            WHERE LinkedEntityId = :acc.Id LIMIT 1
        ];

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        FileUploadManagerController.deleteFile(cdl.ContentDocumentId);
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        List<ContentDocument> remaining = [
            SELECT Id FROM ContentDocument WHERE Id = :cdl.ContentDocumentId
        ];
        Assert.areEqual(0, remaining.size(), 'ContentDocument should have been deleted.');
    }

    @Is{!Environment.IvanTest}
    static void testDeleteFile_nullId() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            FileUploadManagerController.deleteFile(null);
            Assert.fail('Expected AuraHandledException for null contentDocumentId.');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage() != null, 'Exception message should not be null.');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }

    @Is{!Environment.IvanTest}
    static void testDeleteFile_notFound() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        try {
            FileUploadManagerController.deleteFile('069000000000001AAA');
            Assert.fail('Expected AuraHandledException for non-existent file.');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage() != null, 'Exception message should not be null.');
        }
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
    }
}