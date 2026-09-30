public with sharing class ForceStackTriggerHandler {

    /**
     * Handles before insert and before update logic for ForceStack__c.
     * - Auto-sets Deployment Date to today when Pipeline Stage moves to Deploy or Released.
     * - Prevents deactivation of a ForceStack that still has child items.
     */
    public static void handleBeforeInsertUpdate(
        List<ForceStack__c> newList,
        Map<Id, ForceStack__c> oldMap
    ) {
        for (ForceStack__c fs : newList) {
            Boolean isDeployStage = fs.Pipeline_Stage__c == 'Deploy'
                || fs.Pipeline_Stage__c == 'Released';
            Boolean stageChanged = oldMap == null
                || (oldMap.containsKey(fs.Id)
                    && oldMap.get(fs.Id).Pipeline_Stage__c != fs.Pipeline_Stage__c);

            // Auto-set Deployment Date when stage moves to Deploy or Released
            if (isDeployStage && stageChanged && fs.Deployment_Date__c == null) {
                fs.Deployment_Date__c = Date.today();
            }

            // Prevent deactivation when child items exist
            if (oldMap != null && oldMap.containsKey(fs.Id)) {
                ForceStack__c oldFs = oldMap.get(fs.Id);
                if (oldFs.Is_Active__c == true
                        && fs.Is_Active__c == false
                        && fs.Total_Child_Records__c != null
                        && fs.Total_Child_Records__c > 0) {
                    fs.addError(
                        'Cannot deactivate a ForceStack record that still has child items. Remove all items first.'
                    );
                }
            }
        }
    }

    /**
     * Handles after insert and after update logic for ForceStack__c.
     * - Appends a timestamped audit note to Description when Status changes.
     */
    public static void handleAfterInsertUpdate(
        List<ForceStack__c> newList,
        Map<Id, ForceStack__c> oldMap
    ) {
        List<ForceStack__c> toUpdate = new List<ForceStack__c>();

        for (ForceStack__c fs : newList) {
            if (oldMap != null && oldMap.containsKey(fs.Id)) {
                ForceStack__c oldFs = oldMap.get(fs.Id);
                if (oldFs.Status__c != fs.Status__c) {
                    String auditNote = '\n[' + System.now().format('yyyy-MM-dd HH:mm')
                        + '] Status changed from ' + oldFs.Status__c
                        + ' to ' + fs.Status__c + '.';
                    toUpdate.add(new ForceStack__c(
                        Id = fs.Id,
                        Description__c = (fs.Description__c != null ? fs.Description__c : '') + auditNote
                    ));
                }
            }
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}