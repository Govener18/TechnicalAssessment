/**
 * Created by CalebGovender on 2023/06/29.
 */
@IsTest(SeeAllData=false)
public with sharing class PublicHoliday_Test {

    public static final String ValidID = '9810175103083';
    public static final String ValidID2 = '0611152000183';
    public static final String InValidID = '1111A15*0108';

    @IsTest
    static void checkPublicHolidaystest() {
        Test.setMock(HttpCalloutMock.class, new PublicHolidayAPICalloutMockResponse());
        Boolean gotError = false;
        String sYear ='991116';

        Test.startTest();
        try {
            PublicHolidayController.checkPublicHolidays(sYear);
        } catch(Exception ex){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(false, gotError, 'Exception has been throw.');

    }

    @IsTest
    static void saveIDNumbertest() {
        Boolean gotError = false;

        Test.startTest();
        try {
            PublicHolidayController.SaveID(ValidID);
        } catch(Exception ex){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(false, gotError, 'Exception has been throw.');
    }
    
    @IsTest
    static void saveIDNumber2test() {
        Boolean gotError = false;

        Test.startTest();
        try {
            PublicHolidayController.SaveID(ValidID2);
        } catch(Exception ex){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(false, gotError, 'Exception has been throw.');
    }
    
     @IsTest
     static void saveInvalidIDNumbertest() {
        Boolean gotError = false;

        Test.startTest();
        try {
            PublicHolidayController.SaveID(InValidID);
        } catch(Exception ex){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(true, gotError, 'Exception has been throw.');
    }
    
    @IsTest
    static void APIDateConverstiontest() {
        Boolean gotError = false;

        Test.startTest();
        try {
            PublicHolidayController.APIDateConverstion(ValidID2);
        } catch(Exception ex){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(false, gotError, 'Exception has been throw.');
    }

    @IsTest
    static void DateConverstiontest() {
        Boolean gotError = false;

        Test.startTest();
        try {
            PublicHolidayController.DateConverstion(ValidID);
        } catch(Exception ex){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(false, gotError, 'Exception has been throw.');
    }

    @IsTest
    static void HolidayAPIWorking() {
        Test.setMock(HttpCalloutMock.class, new PublicHolidayAPICalloutMockResponse());
        String sYear ='1999';
        Boolean gotError = false;

        Test.startTest();
        try {
            PublicHolidayAPICallout.makeGETCalloutWithParameters(sYear);
        } catch(Exception ex){
                gotError = true;
        }
        Test.stopTest();

        System.assertEquals(false, gotError, 'Exception has not been thrown.');
    }

    @IsTest
    static void HolidayAPINotWorking() {
        Test.setMock(HttpCalloutMock.class, new PublicHolidayAPICalloutMockResponse());
        String sYear ='INVALID';
        Boolean gotError = false;

        Test.startTest();
        HttpResponse response = PublicHolidayAPICallout.makeGETCalloutWithParameters(sYear);
        if(response.getStatusCode() == 400){
            gotError = true;
        }
        Test.stopTest();

        System.assertEquals(true, gotError, 'Exception has been throw.');
    }

}