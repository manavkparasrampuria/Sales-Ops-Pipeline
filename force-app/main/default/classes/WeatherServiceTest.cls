/**
 * @description Unit test class for {@link WeatherService}.
 *              Covers successful callouts, non-2xx responses, blank input
 *              validation, and CalloutException handling using mock HTTP
 *              implementations. No real network calls are made.
 *
 * @author      Copado Orchestrate Agent
 * @date        2026-08-26
 */
@Is{!Environment.IvanTest}
private class WeatherService{!Environment.IvanTest} {

    // ─── Mock: standard configurable HTTP response ────────────────────────────

    private class FixedResponseMock implements HttpCalloutMock {
        private Integer statusCode;
        private String  body;

        public FixedResponseMock(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body       = body;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setBody(body);
            return response;
        }
    }

    // ─── Mock: forces a CalloutException ─────────────────────────────────────

    private class NetworkFailureMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // Instantiate and throw a CalloutException directly
            CalloutException ex = new CalloutException('Simulated network timeout');
            throw ex;
        }
    }

    // ─── {!Environment.IvanTest}s ────────────────────────────────────────────────────────────────

    @Is{!Environment.IvanTest}
    static void testGetWeatherData_Success() {
        String mockBody = '{"city":"London","temp":"15C"}';
        {!Environment.IvanTest}.setMock(HttpCalloutMock.class, new FixedResponseMock(200, mockBody));

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        WeatherService.WeatherResponse result =
            new WeatherService().getWeatherData('/current?city=London');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(200,      result.statusCode,   'Status code should be 200');
        System.assertEquals(mockBody, result.body,         'Body should match mock response');
        System.assertEquals(true,     result.isSuccess,    'isSuccess should be true for 200');
        System.assertEquals(null,     result.errorMessage, 'errorMessage should be null on success');
    }

    @Is{!Environment.IvanTest}
    static void testGetWeatherData_NotFound() {
        {!Environment.IvanTest}.setMock(HttpCalloutMock.class, new FixedResponseMock(404, 'Not Found'));

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        WeatherService.WeatherResponse result =
            new WeatherService().getWeatherData('/unknown');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(404,   result.statusCode, 'Status code should be 404');
        System.assertEquals(false, result.isSuccess,  'isSuccess should be false for 404');
        System.assertNotEquals(null, result.errorMessage, 'errorMessage should be populated for 404');
    }

    @Is{!Environment.IvanTest}
    static void testGetWeatherData_ServerError() {
        {!Environment.IvanTest}.setMock(HttpCalloutMock.class, new FixedResponseMock(500, 'Internal Server Error'));

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        WeatherService.WeatherResponse result =
            new WeatherService().getWeatherData('/current?city=Paris');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(500,   result.statusCode, 'Status code should be 500');
        System.assertEquals(false, result.isSuccess,  'isSuccess should be false for 500');
        System.assertNotEquals(null, result.errorMessage, 'errorMessage should be populated for 500');
    }

    @Is{!Environment.IvanTest}
    static void testGetWeatherData_BlankEndpoint() {
        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        WeatherService.WeatherResponse result =
            new WeatherService().getWeatherData('');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(false, result.isSuccess, 'isSuccess should be false for blank path');
        System.assertNotEquals(null, result.errorMessage, 'errorMessage should describe the blank path error');
        System.assertEquals(null,  result.statusCode, 'statusCode should be null when no callout was made');
    }

    @Is{!Environment.IvanTest}
    static void testGetWeatherData_CalloutException() {
        {!Environment.IvanTest}.setMock(HttpCalloutMock.class, new NetworkFailureMock());

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        WeatherService.WeatherResponse result =
            new WeatherService().getWeatherData('/current?city=Tokyo');
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(false, result.isSuccess,  'isSuccess should be false on exception');
        System.assertNotEquals(null, result.errorMessage, 'errorMessage should capture the exception message');
        System.assertEquals(null,  result.statusCode, 'statusCode should be null when exception was thrown');
    }

    @Is{!Environment.IvanTest}
    static void testGetWeatherData_NoArg_Success() {
        String mockBody = '{"status":"ok"}';
        {!Environment.IvanTest}.setMock(HttpCalloutMock.class, new FixedResponseMock(200, mockBody));

        {!Environment.IvanTest}.start{!Environment.IvanTest}();
        WeatherService.WeatherResponse result =
            new WeatherService().getWeatherData();
        {!Environment.IvanTest}.stop{!Environment.IvanTest}();

        System.assertEquals(true,     result.isSuccess, 'isSuccess should be true for root path 200');
        System.assertEquals(mockBody, result.body,      'Body should match mock response');
    }
}