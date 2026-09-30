@is{!Environment.IvanTest}
public class {!Environment.IvanTest}CopadoTrailHelper {

    static testMethod void testCacheCleanup() {
        copado__Org__c testOrg = new copado__Org__c(Name='{!Environment.IvanTest}');
        insert testOrg;
        
        List<Attachment> atts = new List<Attachment>(); 
        String b1 = '[{"t":"InstalledPackage", "n":"mule",               "b":"", "d":"", "cb":"", "cd":""},'+
                     '{"t":"InstalledPackage", "n":"copado",             "b":"", "d":"", "cb":"", "cd":""},'+
                     '{"t":"CustomObject",     "n":"copado__Project__c", "b":"", "d":"", "cb":"", "cd":""}]';
        Attachment a1 = new Attachment(Name='MetaData', Body=Blob.valueOf(b1), ParentId=testOrg.Id);
        atts.add(a1);
        
        String b2 = '[{"t":"InstalledPackage", "n":"mule",                  "b":"", "d":"", "cb":"", "cd":""},'+
                     '{"t":"ApexClass",        "n":"{!Environment.IvanTest}CopadoTrailHelper", "b":"", "d":"", "cb":"", "cd":""},'+
                     '{"t":"ApexClass",        "n":"CopadoTrailHelper",     "b":"", "d":"", "cb":"", "cd":""}]';
        Attachment a2 = new Attachment(Name='MetaData', Body=Blob.valueOf(b2), ParentId=testOrg.Id);
        atts.add(a2);
        insert atts;
        system.debug('>>> Atts: '+atts);
        
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        CopadoTrailHelper.cacheFile cf = new CopadoTrailHelper.cacheFile('ApexClass', 'CopadoTrailHelper','','','','');
        system.assertEquals('ApexClass', cf.t);
        try{
        	CopadoTrailHelper.trimMetadataCache('copado', '{!Environment.IvanTest}');    
        }
        catch(Exception e){
            system.debug('>>>>>>>>>> Error: '+e);
        }
        
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();
        
        List<Attachment> results = [select Id, Body from Attachment where ParentId=:testOrg.Id];
        
        for(Attachment a : results) {
            List<CopadoTrailHelper.cacheFile> theCache = new List<CopadoTrailHelper.cacheFile>();
            theCache = (List<CopadoTrailHelper.cacheFile>) JSON.deserialize(a.Body.toString(), List<CopadoTrailHelper.cacheFile>.class);
            system.debug('>>> List: '+theCache);
            system.debug('>>> Size: '+theCache.size());
            system.assertEquals(1, theCache.size());
        }
    }
}