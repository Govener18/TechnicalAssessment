/**
 * Created by CalebGovender on 2023/06/29.
 */
@IsTest
public class PublicHolidayAPICalloutMockResponse implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest request) {
        String sRequest = request.toString();
        if (sRequest.contains('INVALID')) {
            return unSuccessfulResponse();
        }
        return successfulResponse();
    }

    private static HttpResponse successfulResponse() {
        String body = '{"meta": {"code": 200},"response": {"holidays": [{"name": "Name of holiday goes here","description": "Description of holiday goes here","date": {"iso": "2018-12-31","datetime": {"year": 2018,"month": 12,"day": 31}},"type": ["Type of Observance goes here"]}]}}';
        HttpResponse response = new HttpResponse();
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }

    private static HttpResponse unSuccessfulResponse() {
        String body = '{"timestamp":"2023-05-23T08:08:41.074+00:00","status":400,"error":"BadRequest","path":"https://calendarific.com/api/v2/holidays"}';
        HttpResponse response = new HttpResponse();
        response.setBody(body);
        response.setStatusCode(400);
        return response;
    }

}