/**
 * Invocable Apex action used by the "Add Two Numbers" Screen Flow (US-0001278).
 * Wrapping the addition in an Action element lets the flow attach a fault
 * path so runtime errors show a user-friendly message instead of failing
 * the interview, per the story's acceptance criteria.
 */
public with sharing class AddTwoNumbersService {

    public class Request {
        @InvocableVariable(label='First Number' required=true)
        public Decimal varNumber1;

        @InvocableVariable(label='Second Number' required=true)
        public Decimal varNumber2;
    }

    public class Response {
        @InvocableVariable(label='Sum')
        public Decimal varSum;
    }

    @InvocableMethod(label='Add Two Numbers' description='Adds two numbers and returns their sum.')
    public static List<Response> addNumbers(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for (Request req : requests) {
            if (req.varNumber1 == null || req.varNumber2 == null) {
                throw new AddTwoNumbersException('Both numbers are required to calculate a sum.');
            }
            Response res = new Response();
            res.varSum = req.varNumber1 + req.varNumber2;
            responses.add(res);
        }
        return responses;
    }

    public class AddTwoNumbersException extends Exception {}
}