/**
 * Created by CalebGovender on 2023/06/28.
 */

({
    CheckAndSaveID : function(component, event){
        var IDNumber = component.get("v.IDInput");
        var SaveIDAction = component.get("c.SaveID");

        SaveIDAction.setParams({
            sIDNumber :IDNumber
        });
        SaveIDAction.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if(result)
                {}
                else
                {
                    alert("Error: " + response.getError()[0].message);
                    window.location.reload();
                }
            }
        });
        $A.enqueueAction(SaveIDAction);
    },

    CheckPublicHolidays : function(component, event){
        var IDNumber = component.get("v.IDInput");
        var CheckPublicHolidayAction = component.get("c.checkPublicHolidays");

        CheckPublicHolidayAction.setParams({
            sIDNumber :IDNumber
        });
        CheckPublicHolidayAction.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if(result)
                {
                    component.set("v.APIValue",result);
                    component.set("v.isHidden",false);
                    component.set("v.isVisible",true);
                }
                else
                {
                    alert("Error: " + response.getError()[0].message);
                    window.location.reload();
                }
            }
        });
        $A.enqueueAction(CheckPublicHolidayAction);
    }
});