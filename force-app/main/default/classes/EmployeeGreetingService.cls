public with sharing class EmployeeGreetingService {

    /**
     * Returns a personalised greeting for the given employee name.
     * @param employeeName The name of the employee to greet.
     * @return A greeting string, or a default message when the name is blank.
     */
    public static String greet(String employeeName) {
        if (String.isBlank(employeeName)) {
            return 'Hello! Welcome to our team.';
        }
        return 'Hello, ' + employeeName.trim() + '! Welcome to our team.';
    }
}