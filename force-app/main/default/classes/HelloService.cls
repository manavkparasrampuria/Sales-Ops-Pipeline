public with sharing class HelloService {

    public static String greetCurrentUser() {
        return 'Hello ' + UserInfo.getName();
    }
}