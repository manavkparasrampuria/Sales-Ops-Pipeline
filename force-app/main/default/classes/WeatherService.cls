/**
 * @description Service class for performing HTTP GET callouts to an external
 *              Weather API. Uses Named Credentials for secure endpoint and
 *              authentication management.
 *
 * @author      Copado Orchestrate Agent
 * @date        2026-08-26
 */
public with sharing class WeatherService {

    // Named Credential API name configured in Setup > Security > Named Credentials
    private static final String NAMED_CREDENTIAL = 'callout:WeatherAPI';

    // Default timeout in milliseconds (10 seconds)
    private static final Integer TIMEOUT_MS = 10000;

    /**
     * @description Wrapper class encapsulating an HTTP response result.
     */
    public class WeatherResponse {
        /** HTTP status code returned by the external API. */
        public Integer statusCode { get; private set; }
        /** Raw response body returned by the external API. */
        public String body      { get; private set; }
        /** Indicates whether the callout was successful (2xx range). */
        public Boolean isSuccess { get; private set; }
        /** Error message populated when the callout fails or returns a non-2xx code. */
        public String errorMessage { get; private set; }

        /**
         * @description Constructor for a successful response.
         * @param statusCode HTTP status code.
         * @param body       Response body as a String.
         */
        public WeatherResponse(Integer statusCode, String body) {
            this.statusCode    = statusCode;
            this.body          = body;
            this.isSuccess     = (statusCode >= 200 && statusCode < 300);
            this.errorMessage  = this.isSuccess
                ? null
                : 'Callout failed with HTTP status: ' + statusCode;
        }

        /**
         * @description Constructor for a callout exception scenario.
         * @param errorMessage Description of the error that occurred.
         */
        public WeatherResponse(String errorMessage) {
            this.statusCode    = null;
            this.body          = null;
            this.isSuccess     = false;
            this.errorMessage  = errorMessage;
        }
    }

    /**
     * @description Performs an HTTP GET callout to the Weather API using the
     *              configured Named Credential. Appends the provided endpoint
     *              path to the Named Credential base URL.
     *
     * @param  endpointPath Relative path to append (e.g. '/current?city=London').
     * @return              A {@link WeatherResponse} containing the status code,
     *                      body, and success flag.
     */
    public WeatherResponse getWeatherData(String endpointPath) {
        if (String.isBlank(endpointPath)) {
            return new WeatherResponse('Endpoint path must not be blank.');
        }

        try {
            HttpRequest request = buildRequest(endpointPath);
            HttpResponse response = new Http().send(request);
            return new WeatherResponse(response.getStatusCode(), response.getBody());
        } catch (CalloutException ex) {
            return new WeatherResponse(
                'Callout exception: ' + ex.getMessage()
            );
        }
    }

    /**
     * @description Overloaded convenience method that calls the root path of
     *              the Named Credential endpoint (no additional path).
     *
     * @return A {@link WeatherResponse} from the root endpoint.
     */
    public WeatherResponse getWeatherData() {
        return getWeatherData('/');
    }

    // ─── Private Helpers ──────────────────────────────────────────────────────

    /**
     * @description Builds and returns a configured HttpRequest object.
     * @param  endpointPath Relative path to append to the Named Credential URL.
     * @return              A ready-to-send HttpRequest.
     */
    private static HttpRequest buildRequest(String endpointPath) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(NAMED_CREDENTIAL + endpointPath);
        request.setMethod('GET');
        request.setTimeout(TIMEOUT_MS);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        return request;
    }
}