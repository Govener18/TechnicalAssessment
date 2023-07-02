/**
 * Created by CalebGovender on 2023/07/01.
 */



import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class PublicHolidayController extends NavigationMixin(LightningElement) {
    callAuraComponent() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__PublicHoliday'
            }
        });
    }
}