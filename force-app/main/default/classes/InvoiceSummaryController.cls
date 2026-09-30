/**
 * @description Controller class for the invoiceSummary LWC component.
 * Retrieves SalesforceInvoice records in a bulkified, sharing-safe manner using WITH USER_MODE.
 * Traverses SalesforceInvoice -> SalesforceContract -> Contract -> Account via explicit
 * Id lookups (relationship dot-traversal is not supported on these platform objects).
 * Logic is decomposed into small @{!Environment.IvanTest}Visible methods so each step can be unit tested in
 * isolation, since SalesforceInvoice / SalesforceContract records cannot be created via DML.
 * @author Copado AI
 */
public with sharing class InvoiceSummaryController {

    /**
     * @description Retrieves a list of invoices with related Account information.
     * Uses WITH USER_MODE to enforce field-level security and sharing rules.
     * @return List<InvoiceWrapper> - wrapped invoice records for the LWC
     */
    @AuraEnabled(cacheable=true)
    public static List<InvoiceWrapper> getInvoices() {
        try {
            List<SalesforceInvoice> invoices = queryInvoices();
            Set<Id> sfContractIds = extractContractIds(invoices);

            Map<Id, Id> sfContractToContractId = new Map<Id, Id>();
            if (!sfContractIds.isEmpty()) {
                sfContractToContractId = buildContractIdMap(queryContractsBySfContractIds(sfContractIds));
            }

            Map<Id, String> contractIdToAccountName = new Map<Id, String>();
            if (!sfContractToContractId.isEmpty()) {
                contractIdToAccountName = buildAccountNameMap(queryAccountsByContractIds(sfContractToContractId.values()));
            }

            return buildResults(invoices, sfContractToContractId, contractIdToAccountName);
        } catch (Exception e) {
            throw new AuraHandledException('Unable to retrieve invoices: ' + e.getMessage());
        }
    }

    @{!Environment.IvanTest}Visible
    private static List<SalesforceInvoice> queryInvoices() {
        return [
            SELECT Id, InvoiceNumber, TotalAmount, SalesforceInvoiceStatus, DueDate, SalesforceContractId
            FROM SalesforceInvoice
            WITH USER_MODE
            ORDER BY DueDate ASC
            LIMIT 200
        ];
    }

    @{!Environment.IvanTest}Visible
    private static List<SalesforceContract> queryContractsBySfContractIds(Set<Id> sfContractIds) {
        return [
            SELECT Id, ContractId
            FROM SalesforceContract
            WHERE Id IN :sfContractIds
            WITH USER_MODE
        ];
    }

    @{!Environment.IvanTest}Visible
    private static List<Contract> queryAccountsByContractIds(List<Id> contractIds) {
        return [
            SELECT Id, Account.Name
            FROM Contract
            WHERE Id IN :contractIds
            WITH USER_MODE
        ];
    }

    @{!Environment.IvanTest}Visible
    private static Set<Id> extractContractIds(List<SalesforceInvoice> invoices) {
        Set<Id> ids = new Set<Id>();
        for (SalesforceInvoice inv : invoices) {
            if (inv.SalesforceContractId != null) {
                ids.add(inv.SalesforceContractId);
            }
        }
        return ids;
    }

    @{!Environment.IvanTest}Visible
    private static Map<Id, Id> buildContractIdMap(List<SalesforceContract> contracts) {
        Map<Id, Id> mapResult = new Map<Id, Id>();
        for (SalesforceContract sc : contracts) {
            if (sc.ContractId != null) {
                mapResult.put(sc.Id, sc.ContractId);
            }
        }
        return mapResult;
    }

    @{!Environment.IvanTest}Visible
    private static Map<Id, String> buildAccountNameMap(List<Contract> contracts) {
        Map<Id, String> mapResult = new Map<Id, String>();
        for (Contract c : contracts) {
            mapResult.put(c.Id, c.Account != null ? c.Account.Name : '');
        }
        return mapResult;
    }

    @{!Environment.IvanTest}Visible
    private static List<InvoiceWrapper> buildResults(
        List<SalesforceInvoice> invoices,
        Map<Id, Id> sfContractToContractId,
        Map<Id, String> contractIdToAccountName
    ) {
        List<InvoiceWrapper> result = new List<InvoiceWrapper>();
        for (SalesforceInvoice inv : invoices) {
            String accountName = '';
            Id relatedContractId = sfContractToContractId.get(inv.SalesforceContractId);
            if (relatedContractId != null && contractIdToAccountName.containsKey(relatedContractId)) {
                accountName = contractIdToAccountName.get(relatedContractId);
            }
            result.add(wrapInvoice(inv, accountName));
        }
        return result;
    }

    @{!Environment.IvanTest}Visible
    private static InvoiceWrapper wrapInvoice(SalesforceInvoice inv, String accountName) {
        return new InvoiceWrapper(
            inv.Id,
            inv.InvoiceNumber,
            accountName,
            inv.TotalAmount,
            inv.SalesforceInvoiceStatus,
            inv.DueDate
        );
    }

    /**
     * @description Wrapper class to shape invoice data for the LWC datatable.
     */
    public class InvoiceWrapper {
        @AuraEnabled public Id invoiceId;
        @AuraEnabled public String invoiceNumber;
        @AuraEnabled public String accountName;
        @AuraEnabled public Decimal amount;
        @AuraEnabled public String status;
        @AuraEnabled public Date dueDate;

        public InvoiceWrapper(Id invoiceId, String invoiceNumber, String accountName, Decimal amount, String status, Date dueDate) {
            this.invoiceId = invoiceId;
            this.invoiceNumber = invoiceNumber;
            this.accountName = accountName;
            this.amount = amount;
            this.status = status;
            this.dueDate = dueDate;
        }
    }
}