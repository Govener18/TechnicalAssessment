/**
 * Created by CalebGovender on 2023/06/28.
 * @description : Contoller for Public Holiday Aura Component
 */

public with sharing class PublicHolidayController {

    /**
    * @description : Aura Method to retrieve and proccess User Input
    */
    @AuraEnabled
    public static Boolean SaveID(String sIDNumber){
        Boolean bReturn;
        PublicHolidayWrapper phw = new PublicHolidayWrapper();
        phw = splitID(sIDNumber);
            try{
                PublicHolidayController.InsertID(sIDNumber,phw);
                bReturn = true;
            }
            catch (Exception ex){
                bReturn = false;
            }
        return bReturn;
    }

    /**
    * @description : Aura Method to call API callout mehtod
    */
    @AuraEnabled
    public static String checkPublicHolidays(String sIDNumber){
        Map<String,String> response = PublicHolidayController.checkPublicHolidaysAPICAllout(sIDNumber.substring(0,6));
        return String.valueOf(response);
    }

    /**
    * @description : Method to add the century to the date
    */
    public static String APIDateConverstion(String sDate) {
        String sConvertedDate;
        Integer iYear = Integer.valueOf(sDate.substring(0,2));
        String sTodayYear = String.valueOf(Date.today().year()).substring(2,4);
        String sYear = sDate.substring(0,2);
        String sMonth = sDate.substring(2,4);
        String sDay = sDate.substring(4,6);

        if(iYear < Integer.valueOf(sTodayYear)){
            sConvertedDate = '20' + sYear  + '-' + sMonth + '-' + sDay;
        }else{
            sConvertedDate = '19' + sYear  + '-' + sMonth + '-' + sDay;
        }
        return sConvertedDate;
    }

    /**
    * @description : Method to add the century to the date and allows Date to be converted to Date from String
    */
    public static String DateConverstion(String sDate) {
        String sConvertedDate;
        Integer iYear = Integer.valueOf(sDate.substring(0,2));
        String sTodayYear = String.valueOf(Date.today().year()).substring(2,4);
        String sYear = sDate.substring(0,2);
        String sMonth = sDate.substring(3,5);
        String sDay = sDate.substring(6,8);


        if(iYear < Integer.valueOf(sTodayYear)){
            sConvertedDate = '20' + sYear  + '-' + sMonth + '-' + sDay;
        }else{
            sConvertedDate = '19' + sYear + '-' + sMonth + '-' + sDay;
        }
        return sConvertedDate;
    }

        /**
        * @description : Method to Insert Valid ID Number
        */
    public static void InsertID(String sIDNumber, PublicHolidayWrapper PHW) {

        List<ID_Number__c> lExist =  [SELECT Id,Name,Search_Counter__c FROM ID_Number__c WHERE Name =: sIDNumber];
        List<PublicHolidayWrapper>  lphw = new List<PublicHolidayWrapper>();
        lphw.add(PHW);

        if (lExist.size() > 0) {
            for(ID_Number__c itemExist : lExist) {
                 itemExist.Search_Counter__c ++;
            }
            Database.upsert(lExist,true);
        }
        else {
            ID_Number__c newRecord = new ID_Number__c();
            for (PublicHolidayWrapper item: lphw){
                newRecord.Name = item.sName;
                newRecord.Date_of_Birth__c = Date.valueOf(PublicHolidayController.DateConverstion(item.dDOB));
                newRecord.Gender__c = item.sGender;
                newRecord.Citizenship__c = item.sCitizen;
                newRecord.Checksum_Digit__c = item.iChecksumDigit;
                newRecord.Search_Counter__c = 1;
            }
            Database.insert(newRecord,true);
        }
    }

    /**
    * @description : Method to split the ID Number into relevant information
    */
    public static PublicHolidayWrapper splitID(String sIDNumber) {
        PublicHolidayWrapper phw = new PublicHolidayWrapper();
        Integer iCitizen = Integer.valueOf(sIDNumber.substring(10, 11));
            phw.sName = sIDNumber;
            phw.dDOB = sIDNumber.substring(0,2)  + '-' + sIDNumber.substring(2,4) + '-' + sIDNumber.substring(4,6);
            if (Integer.valueOf(sIDNumber.substring(6, 10)) > 5000) {
                phw.sGender = 'Male';
            } else {
                phw.sGender = 'Female';
            }
            if (iCitizen== 0){
                phw.sCitizen = 'Citizen';
            } else if (iCitizen == 1){
                phw.sCitizen = 'Resident';
            }
            phw.iChecksumDigit = Integer.valueOf(sIDNumber.substring(12));
        return phw;
    }

    /**
    * @description : Method to call PublicHolidayAPICallout and make the API Callout
    */
    public static Map<String,String> checkPublicHolidaysAPICAllout(String sYear){
        HttpResponse response = PublicHolidayAPICallout.makeGETCalloutWithParameters(PublicHolidayController.APIDateConverstion(sYear).substring(0,4));
        Map<String,String> mDisplay = new Map<String,String>();
        mDisplay = deSerializeBody(response.getBody());
        return mDisplay;
    }

    /**
    * @description : Method to deSerialize API response
    */
    public static Map<String,String> deSerializeBody (String sResponse){
        Map<String, Object> jsonData = (Map<String, Object>)JSON.deserializeUntyped(sResponse);
        Map<String, Object> response = (Map<String, Object>)jsonData.get('response');
        List<Object> holidaysList = (List<Object>)response.get('holidays');

        List<Holiday> holidays = new List<Holiday>();

        for (Object holidayObj : holidaysList) {
            Map<String, Object> holidayData = (Map<String, Object>)holidayObj;
            Holiday holiday = new Holiday();
            holiday.name = (String)holidayData.get('name');

            Map<String, Object> dateData = (Map<String, Object>)holidayData.get('date');
            DateWrapper dateWrapper = new DateWrapper();
            dateWrapper.iso = (String)dateData.get('iso');
            holiday.Ddate = dateWrapper;

            holidays.add(holiday);
        }

        Map<String,String> mCleanResponse = new Map<String, String>();
        for (Holiday holiday : holidays) {
            mCleanResponse.put(holiday.name,holiday.Ddate.iso);

        }
        return mCleanResponse;
    }

    /**
    * @description : Wrapper Class for relevant ID Number Information
    */
    public class PublicHolidayWrapper {
        public String sName {get; set;}
        public String dDOB {get; set;}
        public String sGender {get; set;}
        public String sCitizen {get; set;}
        public Integer iChecksumDigit {get; set;}
    }

    public class PublicHolidayControllerException extends Exception {}

    public class Holiday {
        public String name { get; set; }
        public DateWrapper Ddate { get; set; }
    }

    public class DateWrapper {
        public String iso { get; set; }
    }
}