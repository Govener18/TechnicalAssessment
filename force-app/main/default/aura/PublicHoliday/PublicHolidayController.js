/**
 * Created by CalebGovender on 2023/06/28.
 */

({
    onInputChange : function(component, event, helper) {
        var regex= new RegExp('^.*[-!$%^&*()_+|~=`{}[\\]:";\'<>?,.\/A-Za-z]+.*$');
        var idNumberString = component.get("v.IDInput");
        var isButtonDisabled;
            if (idNumberString.length < 13) {
                isButtonDisabled = true;
                alert("ID Number to short");
            }else if(parseInt(idNumberString.charAt(10)) > 1){
                isButtonDisabled = true;
                alert("Invalid ID");
            }else if(regex.test(idNumberString)){
                isButtonDisabled = true;
                alert("ID Number cannot contain Special characters or Letters");
            }else{
                isButtonDisabled = false;
            }
        component.set("v.isIDValid", isButtonDisabled);
    },

    onCheckClick : function(component, event, helper) {
        helper.CheckAndSaveID(component);
        helper.CheckPublicHolidays(component);
    }
});