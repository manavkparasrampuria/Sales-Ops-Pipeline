/**
 * DemoBadApexClass{!Environment.IvanTest}
 * PURPOSE: {!Environment.IvanTest} class that deliberately FAILS for demo screenshots.
 *
 * FAILURES TRIGGERED:
 * [Apex {!Environment.IvanTest}] System.assert(false) forces a hard test failure
 * [Apex {!Environment.IvanTest}] Coverage is ~30% because uncoveredMethod() and calculateDiscount()
 *             are never called, keeping coverage below the 75% threshold
 */
@Is{!Environment.IvanTest}
private class DemoBadApexClass{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGetAccounts_Fails() {
        // Arrange: insert a test account
        Account testAcc = new Account(Name = 'Demo {!Environment.IvanTest} Account');
        insert testAcc;

        // Act: call the method (covers getAccounts only)
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Account> results = DemoBadApexClass.getAccounts();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        // [INTENTIONAL FAILURE] Hard assert(false) forces Apex test to FAIL
        // This simulates a broken assertion scenario for demo purposes
        System.assert(false, 'DEMO FAILURE: This assertion is intentionally false to trigger a failed Apex test result in Copado.');
    }

    @Is{!Environment.IvanTest}
    static void testSearchContacts_PartialCoverage() {
        // Covers searchContacts() but still leaves uncoveredMethod()
        // and calculateDiscount() untouched, keeping total coverage low.
        Contact c = new Contact(LastName = 'DemoContact');
        insert c;

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        List<Contact> results = DemoBadApexClass.searchContacts('DemoContact');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        // No assertion here intentionally - just coverage padding
        // (also a PMD: ApexUnit{!Environment.IvanTest}ClassShouldHaveAsserts violation if PMD rule is enabled)
    }

    // NOTE: updateAccount(), uncoveredMethod(), and calculateDiscount()
    // are deliberately NOT tested, keeping coverage well below 75%.
}