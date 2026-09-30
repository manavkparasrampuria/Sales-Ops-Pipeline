/**
 * @class       NMD_OrderSubmissionManager
 * @description Handles order submission logic for SCS products, including
 *              the creation of Surgery__c records for each Order Item.
 *
 *              SPLIT SERIAL LOGIC:
 *              For a specific model number (SPLIT_MODEL_NUMBER), instead of
 *              creating one Surgery record per Order Item, two are created.
 *              The 10-digit serial number on the Order Item is split into two
 *              5-character halves, each stamped on a separate Surgery record.
 *
 *              Example:
 *                OrderItem.Serial_Number__c = '1234567890'
 *                Surgery Record 1 -> Serial_Number__c = '12345'
 *                Surgery Record 2 -> Serial_Number__c = '67890'
 *
 * @author      Copado Build Agent
 * @date        2026-08-09
 */
public with sharing class NMD_OrderSubmissionManager {

    // ─── Constants ────────────────────────────────────────────────────────────

    /** Model number that triggers the dual-surgery / split-serial logic. */
    @{!Environment.IvanTest}Visible
    private static final String SPLIT_MODEL_NUMBER = 'MODEL-SCS-SPLIT';

    /** Expected total length of a serial number eligible for splitting. */
    private static final Integer SERIAL_TOTAL_LENGTH = 10;

    /** Number of characters in each split half. */
    private static final Integer SERIAL_HALF_LENGTH = 5;

    // ─── Public Entry Point ───────────────────────────────────────────────────

    /**
     * @description Creates Surgery__c records for every Order Item linked to
     *              the given Order Id.
     *              - Standard model numbers  -> 1 Surgery per Order Item.
     *              - SPLIT_MODEL_NUMBER       -> 2 Surgeries per Order Item,
     *                serial number split into two 5-char halves.
     *
     * @param orderId  The Id of the Order whose items should be processed.
     */
    public static void createSurgeryForRelatedOrder(Id orderId) {
        if (orderId == null) {
            return;
        }

        // Query all Order Items for the given Order, including product details.
        List<OrderItem> items = [
            SELECT Id,
                   OrderId,
                   Serial_Number__c,
                   Product2Id,
                   Product2.Name,
                   Product2.ProductCode
            FROM   OrderItem
            WHERE  OrderId = :orderId
        ];

        if (items.isEmpty()) {
            return;
        }

        List<Surgery__c> surgeriesToInsert = new List<Surgery__c>();

        for (OrderItem item : items) {
            String modelNumber = (item.Product2 != null)
                ? item.Product2.ProductCode
                : null;
            String productName = (item.Product2 != null)
                ? item.Product2.Name
                : null;

            if (SPLIT_MODEL_NUMBER.equals(modelNumber)) {
                // ── Split logic: create 2 Surgery records ──────────────────
                surgeriesToInsert.addAll(
                    buildSplitSurgeries(item, modelNumber, productName)
                );
            } else {
                // ── Standard logic: create 1 Surgery record ────────────────
                surgeriesToInsert.add(
                    buildSingleSurgery(item, modelNumber, productName, item.Serial_Number__c)
                );
            }
        }

        if (!surgeriesToInsert.isEmpty()) {
            if (Schema.sObjectType.Surgery__c.isCreateable()) {
                insert surgeriesToInsert;
            }
        }
    }

    // ─── Private Helpers ──────────────────────────────────────────────────────

    /**
     * @description Builds two Surgery__c records by splitting the Order Item's
     *              serial number into two 5-character halves.
     *              If the serial is blank or shorter than 10 chars, both
     *              Surgery records are created with a null serial number and
     *              an error is logged to avoid an unhandled exception.
     *
     * @param item         The source Order Item.
     * @param modelNumber  The product model number.
     * @param productName  The product name.
     * @return             A list of exactly 2 Surgery__c records.
     */
    private static List<Surgery__c> buildSplitSurgeries(
        OrderItem item,
        String    modelNumber,
        String    productName
    ) {
        String serial = item.Serial_Number__c;
        String firstHalf  = null;
        String secondHalf = null;

        if (String.isNotBlank(serial) && serial.length() >= SERIAL_TOTAL_LENGTH) {
            firstHalf  = serial.substring(0, SERIAL_HALF_LENGTH);
            secondHalf = serial.substring(SERIAL_HALF_LENGTH, SERIAL_TOTAL_LENGTH);
        } else {
            System.debug(LoggingLevel.WARN,
                'NMD_OrderSubmissionManager: Serial number on OrderItem ' +
                item.Id + ' is blank or too short to split. ' +
                'Surgery records will be created with null serial numbers.');
        }

        return new List<Surgery__c>{
            buildSingleSurgery(item, modelNumber, productName, firstHalf),
            buildSingleSurgery(item, modelNumber, productName, secondHalf)
        };
    }

    /**
     * @description Builds a single Surgery__c record from an Order Item.
     *
     * @param item          The source Order Item.
     * @param modelNumber   The product model number.
     * @param productName   The product name.
     * @param serialNumber  The serial number to stamp on the Surgery record.
     * @return              A new (unsaved) Surgery__c record.
     */
    private static Surgery__c buildSingleSurgery(
        OrderItem item,
        String    modelNumber,
        String    productName,
        String    serialNumber
    ) {
        return new Surgery__c(
            Order__c        = item.OrderId,
            Order_Item__c   = item.Id,
            Serial_Number__c = serialNumber,
            Model_Number__c  = modelNumber,
            Product_Name__c  = productName
        );
    }
}