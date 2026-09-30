/**
 * @description Apex controller for the fileUploadManager LWC bundle.
 *              Handles retrieval and deletion of files linked to a record.
 *              Leverages ContentDocument, ContentVersion, and ContentDocumentLink.
 * @author      Copado Build Agent
 * @date        2026-08-08
 */
public with sharing class FileUploadManagerController {

    /**
     * @description Retrieves all files linked to a given record.
     * @param  recordId  The Id of the parent record.
     * @return           List of FileWrapper objects representing linked files.
     */
    @AuraEnabled(cacheable=true)
    public static List<FileWrapper> getFiles(Id recordId) {
        if (recordId == null) {
            throw new AuraHandledException('Record Id is required.');
        }

        List<FileWrapper> files = new List<FileWrapper>();

        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId,
                   ContentDocument.Title,
                   ContentDocument.FileType,
                   ContentDocument.ContentSize,
                   ContentDocument.CreatedDate,
                   ContentDocument.CreatedBy.Name,
                   ContentDocument.LatestPublishedVersionId
            FROM   ContentDocumentLink
            WHERE  LinkedEntityId = :recordId
            ORDER BY ContentDocument.CreatedDate DESC
        ];

        for (ContentDocumentLink link : links) {
            FileWrapper fw        = new FileWrapper();
            fw.contentDocumentId  = link.ContentDocumentId;
            fw.versionId          = link.ContentDocument.LatestPublishedVersionId;
            fw.title              = link.ContentDocument.Title;
            fw.fileType           = link.ContentDocument.FileType;
            fw.contentSize        = link.ContentDocument.ContentSize;
            fw.createdDate        = link.ContentDocument.CreatedDate;
            fw.createdByName      = link.ContentDocument.CreatedBy.Name;
            files.add(fw);
        }

        return files;
    }

    /**
     * @description Deletes a ContentDocument (and all its versions) by Id.
     * @param  contentDocumentId  The Id of the ContentDocument to delete.
     */
    @AuraEnabled
    public static void deleteFile(Id contentDocumentId) {
        if (contentDocumentId == null) {
            throw new AuraHandledException('Content Document Id is required.');
        }

        List<ContentDocument> docs = [
            SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId LIMIT 1
        ];

        if (docs.isEmpty()) {
            throw new AuraHandledException('File not found or already deleted.');
        }

        try {
            delete docs;
        } catch (DmlException e) {
            throw new AuraHandledException('Error deleting file: ' + e.getMessage());
        }
    }

    /**
     * @description Inner wrapper class representing a file record for the LWC.
     */
    public class FileWrapper {
        @AuraEnabled public Id       contentDocumentId { get; set; }
        @AuraEnabled public Id       versionId         { get; set; }
        @AuraEnabled public String   title             { get; set; }
        @AuraEnabled public String   fileType          { get; set; }
        @AuraEnabled public Integer  contentSize       { get; set; }
        @AuraEnabled public DateTime createdDate       { get; set; }
        @AuraEnabled public String   createdByName     { get; set; }
    }
}