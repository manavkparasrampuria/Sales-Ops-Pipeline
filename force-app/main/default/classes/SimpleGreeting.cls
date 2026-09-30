public with sharing class SimpleGreeting {

    private String name;

    public SimpleGreeting(String name) {
        this.name = name;
    }

    public String greet() {
        return 'Hello, ' + this.name + '! Welcome to Salesforce.';
    }

    public static String greetStatic(String name) {
        return 'Hello, ' + name + '! Welcome to Salesforce.';
    }
}