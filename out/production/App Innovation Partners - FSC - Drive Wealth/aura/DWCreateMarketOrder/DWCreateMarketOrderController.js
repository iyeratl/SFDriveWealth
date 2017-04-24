({
    doInit : function(component, event, helper) {
        helper.getAccountInfo(component, helper);
        /**/
    },
    handleEvtOrderCreated: function(component, event, helper){
        component.find('utils').log('Handling EvtOrderCreated Event: ' + event);

        /*

        //show symbol search and hide order form
        $A.util.addClass(component.find('searchSymbol'), 'slds-show');
        $A.util.addClass(component.find('createMarketOrderForm'), 'slds-hide');

        $A.util.removeClass(component.find('createMarketOrderForm'), 'slds-show');
        $A.util.removeClass(component.find('searchSymbol'), 'slds-hide');

        */
    },
    handleEvtInstrumentInfo: function(component, event, helper) {
        component.find('utils').log('Handling EvtInstrumentInfo Event: ', event);

        //Instrument information will be used when order form is built
        component.set('v.instrument', event.getParam("instrument"));

        helper.hideSearchSymbolForm(component, helper);
        helper.showCreateMarketOrderForm(component, helper);
    },
    searchSymbol: function(component, event, helper) {
        //Show symbol search form
        helper.showSearchSymbolForm(component, helper);

        //Hide/Destroy market order form
        helper.hideCreateMarketOrderForm(component, helper);
    }

})