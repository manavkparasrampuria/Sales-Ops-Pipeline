/**
 * @description Invocable Apex action for the "Add Three Numbers" user story (US-0020774).
 *              Accepts three Decimal inputs via Flow, validates that none are null,
 *              computes their sum, and returns the result.
 *              Follows the same Request/Response pattern as AddTwoNumbersService (US-0001278)
 *              so the two classes remain consistent and easy to maintain together.
 *
 * @author      Ashok Kosinepalli
 * @story       US-0020774
 * @date        2026-09-08
 */
public with sharing class AddThreeNumbersService {

    // ─── Inner Classes ────────────────────────────────────────────────────────

    /**
     * @description Input wrapper consumed by the @InvocableMethod.
     *              Each variable maps to a Flow input variable.
     */
    public class Request {
        @InvocableVariable(label='First Number' required=true)
        public Decimal varNumber1;

        @InvocableVariable(label='Second Number' required=true)
        public Decimal varNumber2;

        @InvocableVariable(label='Third Number' required=true)
        public Decimal varNumber3;
    }

    /**
     * @description Output wrapper returned to the calling Flow.
     */
    public class Response {
        @InvocableVariable(label='Sum')
        public Decimal varSum;
    }

    /**
     * @description Custom exception thrown when any required input is null.
     */
    public class AddThreeNumbersException extends Exception {}

    // ─── Invocable Method ─────────────────────────────────────────────────────

    /**
     * @description Adds three Decimal numbers and returns their sum.
     *              Throws AddThreeNumbersException if any input is null,
     *              allowing the calling Flow to handle the fault gracefully.
     *
     * @param  requests  List of Request objects supplied by the Flow engine.
     * @return           List of Response objects, one per request.
     * @throws AddThreeNumbersException when any input variable is null.
     */
    @InvocableMethod(
        label='Add Three Numbers'
        description='Adds three numbers and returns their sum.'
    )
    public static List<Response> addNumbers(List<Request> requests) {
        List<Response> responses = new List<Response>();

        for (Request req : requests) {
            if (req.varNumber1 == null || req.varNumber2 == null || req.varNumber3 == null) {
                throw new AddThreeNumbersException(
                    'All three numbers are required to calculate a sum.'
                );
            }

            Response res = new Response();
            res.varSum = req.varNumber1 + req.varNumber2 + req.varNumber3;
            responses.add(res);
        }

        return responses;
    }
}