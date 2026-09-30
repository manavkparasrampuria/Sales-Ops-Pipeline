// {!Environment.IvanTest} Class — Less than 50% coverage + Failing assertion
@Is{!Environment.IvanTest}(critical=true)
private class AccountService{!Environment.IvanTest} {

    @Is{!Environment.IvanTest}
    static void testGetAccountType_Customer() {
        Account acc = new Account(Name = '{!Environment.IvanTest} Account', Type = 'Customer');

        String result = AccountService.getAccountType(acc);

        // This assertion will FAIL
        System.assertEquals('Wrong Result', result, 'Account type message did not match');
    }
}