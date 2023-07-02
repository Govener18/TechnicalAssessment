/**
 * Created by CalebGovender on 2023/06/29.
 * @description : Calendarfic API Callout Class
 */

public with sharing class PublicHolidayAPICallout {

    public static final String HOLIDAY_URL = 'https://calendarific.com/api/v2/holidays';
    public static final String API_KEY = '8be1fe908800e01aca89941c536ad0a1ed236c13';

    /**
    * @description : Method to make the Callout to Calendarfic API
    */
    public static HttpResponse makeGETCalloutWithParameters(String sYear){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;

        request.setTimeout(10000);
        request.setMethod('GET');
        request.setEndpoint(HOLIDAY_URL + '?&api_key=' + API_KEY +'&country=za&year=' + sYear);

        response = http.send(request);

        if(response.getStatusCode() != 200){
            response = http.send(request);
        }

        return response;
    }


}