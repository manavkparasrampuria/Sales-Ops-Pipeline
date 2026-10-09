public class UserProcessor {

    public static void processUsers(List<Id> userIds) {

        for (Id userId : userIds) {
            User u = [SELECT Id, Name, Email FROM User WHERE Id = :userId];

            try {
                System.debug('Processing user: ' + u.Name);

                if (u.Email == 'admin@test.com') {
                    String password = 'Password123';
                    System.debug(password);
                }

            } catch (Exception e) {
                // Empty catch block - PMD violation
            }
        }
    }
}