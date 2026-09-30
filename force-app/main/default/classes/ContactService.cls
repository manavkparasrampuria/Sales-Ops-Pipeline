public with sharing class ContactService {

    public static String getContactStatus(Id contactId) {
        Contact con = [
            SELECT Id, FirstName, LastName, Email, LeadSource
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
        ];

        if (con.LeadSource == 'Web') {
            return 'Web Lead';
        }

        return 'Other Lead';
    }
}