/**
 * @description Trigger handler for the Asset object.
 *              Follows a single-trigger, handler-class pattern to keep
 *              trigger logic organised, testable, and governor-limit safe.
 *              All business logic is delegated to AssetService.
 * @author      Copado Build Agent
 * @date        2026-08-14
 */
public with sharing class AssetTriggerHandler {

    // ─── Entry Points (called from AssetTrigger) ──────────────────────────────

    /**
     * @description Handles all before-insert logic.
     * @param newAssets Trigger.new
     */
    public static void onBeforeInsert(List<Asset> newAssets) {
        AssetService.setDefaultStatus(newAssets);
        AssetService.requireAccount(newAssets);
        AssetService.validateQuantity(newAssets);
        AssetService.validateDates(newAssets);
        AssetService.validateStatusTransition(newAssets, null);
    }

    /**
     * @description Handles all before-update logic.
     * @param newAssets   Trigger.new
     * @param oldAssetMap Trigger.oldMap
     */
    public static void onBeforeUpdate(
        List<Asset> newAssets,
        Map<Id, Asset> oldAssetMap
    ) {
        AssetService.validateQuantity(newAssets);
        AssetService.validateDates(newAssets);
        AssetService.validateStatusTransition(newAssets, oldAssetMap);
    }

    /**
     * @description Handles all after-insert logic.
     * @param newAssets   Trigger.new
     * @param newAssetMap Trigger.newMap
     */
    public static void onAfterInsert(
        List<Asset> newAssets,
        Map<Id, Asset> newAssetMap
    ) {
        // Reserved for future after-insert logic (e.g. creating related records,
        // sending notifications, updating Account asset counts).
    }

    /**
     * @description Handles all after-update logic.
     * @param newAssets   Trigger.new
     * @param oldAssetMap Trigger.oldMap
     */
    public static void onAfterUpdate(
        List<Asset> newAssets,
        Map<Id, Asset> oldAssetMap
    ) {
        // Reserved for future after-update logic (e.g. status-change notifications).
    }
}