/**
 * Generates a random name and assigns it to Account records.
 * Exposed as an Invocable method so it can be called from Flows, Quick Actions, or Process Builder.
 */
public with sharing class AccountRandomNameGenerator {

    private static final List<String> FIRST_PARTS = new List<String>{
        'Blue', 'Silver', 'Golden', 'Northern', 'Summit', 'Bright', 'Rapid', 'Prime', 'Crystal', 'Vertex'
    };

    private static final List<String> SECOND_PARTS = new List<String>{
        'Peak', 'Ridge', 'Harbor', 'Solutions', 'Ventures', 'Dynamics', 'Industries', 'Group', 'Works', 'Labs'
    };

    /**
     * Invocable entry point. Accepts a list of Account Ids, generates a random name
     * for each Account, and updates them in a single bulkified DML operation.
     * @param accountIds List of Account Ids to rename.
     */
    @InvocableMethod(label='Generate Random Account Name' description='Assigns a randomly generated name to the given Accounts')
    public static void generateRandomNames(List<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            accountsToUpdate.add(new Account(
                Id = accId,
                Name = generateRandomName()
            ));
        }

        update accountsToUpdate;
    }

    /**
     * Builds a single random, human-readable company-style name.
     * @return A randomly generated name string, e.g. "Silver Ridge 4821".
     */
    public static String generateRandomName() {
        String first = FIRST_PARTS[Math.mod(Math.abs(Crypto.getRandomInteger()), FIRST_PARTS.size())];
        String second = SECOND_PARTS[Math.mod(Math.abs(Crypto.getRandomInteger()), SECOND_PARTS.size())];
        Integer suffix = Math.mod(Math.abs(Crypto.getRandomInteger()), 10000);
        return first + ' ' + second + ' ' + suffix;
    }
}