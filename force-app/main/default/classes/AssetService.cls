/**
 * @description Service class for Asset Management business logic.
 *              Handles validation, status transitions, and helper operations
 *              for the Asset object. All DML is performed in the trigger handler
 *              to keep this class testable and reusable.
 * @author      Copado Build Agent
 * @date        2026-08-14
 */
public with sharing class AssetService {

    // ─── Constants ────────────────────────────────────────────────────────────

    /** Valid forward status transitions for an Asset lifecycle. */
    private static final Map<String, Set<String>> VALID_TRANSITIONS = new Map<String, Set<String>>{
        'Purchased'   => new Set<String>{ 'Shipped', 'Registered' },
        'Shipped'     => new Set<String>{ 'Installed', 'Registered' },
        'Installed'   => new Set<String>{ 'Registered' },
        'Registered'  => new Set<String>()
    };

    // ─── Public Methods ───────────────────────────────────────────────────────

    /**
     * @description Validates that the status transition on each Asset is allowed.
     *              Adds a field-level error on invalid transitions.
     * @param newAssets  List of Assets from Trigger.new
     * @param oldAssetMap Map of Assets from Trigger.oldMap (null on insert)
     */
    public static void validateStatusTransition(
        List<Asset> newAssets,
        Map<Id, Asset> oldAssetMap
    ) {
        for (Asset a : newAssets) {
            String newStatus = a.Status;
            if (oldAssetMap == null) {
                // On insert, only 'Purchased' or 'Shipped' are valid starting statuses
                if (newStatus != null
                    && newStatus != 'Purchased'
                    && newStatus != 'Shipped') {
                    a.Status.addError(
                        'New assets must start with a status of Purchased or Shipped.'
                    );
                }
                continue;
            }

            String oldStatus = oldAssetMap.get(a.Id)?.Status;
            if (oldStatus == newStatus || newStatus == null) {
                continue; // No change, skip
            }

            Set<String> allowed = VALID_TRANSITIONS.get(oldStatus);
            if (allowed == null || !allowed.contains(newStatus)) {
                a.Status.addError(
                    'Invalid status transition from "' + oldStatus
                    + '" to "' + newStatus + '".'
                );
            }
        }
    }

    /**
     * @description Ensures that every Asset has a non-null AccountId.
     *              Adds a field-level error when the account is missing.
     * @param newAssets List of Assets from Trigger.new
     */
    public static void requireAccount(List<Asset> newAssets) {
        for (Asset a : newAssets) {
            if (a.AccountId == null) {
                a.AccountId.addError('An Asset must be linked to an Account.');
            }
        }
    }

    /**
     * @description Sets the default Status to 'Purchased' when none is provided
     *              on insert.
     * @param newAssets List of Assets from Trigger.new
     */
    public static void setDefaultStatus(List<Asset> newAssets) {
        for (Asset a : newAssets) {
            if (String.isBlank(a.Status)) {
                a.Status = 'Purchased';
            }
        }
    }

    /**
     * @description Validates that Quantity is a positive number when provided.
     * @param newAssets List of Assets from Trigger.new
     */
    public static void validateQuantity(List<Asset> newAssets) {
        for (Asset a : newAssets) {
            if (a.Quantity != null && a.Quantity <= 0) {
                a.Quantity.addError('Quantity must be greater than zero.');
            }
        }
    }

    /**
     * @description Validates that InstallDate is not before PurchaseDate.
     * @param newAssets List of Assets from Trigger.new
     */
    public static void validateDates(List<Asset> newAssets) {
        for (Asset a : newAssets) {
            if (a.InstallDate != null
                && a.PurchaseDate != null
                && a.InstallDate < a.PurchaseDate) {
                a.InstallDate.addError(
                    'Install Date cannot be earlier than Purchase Date.'
                );
            }
        }
    }
}