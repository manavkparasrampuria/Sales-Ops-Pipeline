@is{!Environment.IvanTest}(SeeAllData=true)
public class LeadStatusCheck{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void checkLead() {
        String info = LeadStatusCheck.getLeadInfo();
        System.debug('LEAD_INFO: ' + info);

        if (info == 'NOT_FOUND') {
            System.debug('LEAD_NOT_FOUND');
            return;
        }

        if (!info.contains('IsConverted=true')) {
            List<Lead> leads = [SELECT Id, Name FROM Lead WHERE Name = '{!Environment.IvanTest}_Lead_1910334' LIMIT 1];
            Lead l = leads[0];

            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.Id);
            lc.setConvertedStatus('Qualified');
            lc.setDoNotCreateOpportunity(false);
            lc.setOpportunityName(l.Name + ' - Opportunity');

            Database.LeadConvertResult lcr = Database.convertLead(lc);

            if (lcr.isSuccess()) {
                System.debug('CONVERSION_SUCCESS: AccountId=' + lcr.getAccountId() + '|ContactId=' + lcr.getContactId() + '|OpportunityId=' + lcr.getOpportunityId());

                Account acc = [SELECT Name FROM Account WHERE Id = :lcr.getAccountId()];
                Contact con = [SELECT Name FROM Contact WHERE Id = :lcr.getContactId()];
                Opportunity opp = [SELECT Name, Id FROM Opportunity WHERE Id = :lcr.getOpportunityId()];

                System.debug('ACCOUNT_NAME: ' + acc.Name);
                System.debug('CONTACT_NAME: ' + con.Name);
                System.debug('OPPORTUNITY_NAME: ' + opp.Name);
                System.debug('OPPORTUNITY_ID: ' + opp.Id);
            } else {
                for (Database.Error err : lcr.getErrors()) {
                    System.debug('CONVERSION_ERROR: ' + err.getMessage());
                }
            }
        } else {
            System.debug('ALREADY_CONVERTED: ' + info);
        }
    }
}