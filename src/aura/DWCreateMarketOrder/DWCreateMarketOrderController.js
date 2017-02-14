({
    doInit : function(component, event, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            data: {
                operation: "DWCreateOrder_Controller",
                input: {
                    AccountID: component.get('v.recordId'),
                    mode: 'getAccount'
                }
            },
            callBackMethod: function (data) {
                var acc = data.output;
                component.set('v.acc', acc);

                if($A.util.isUndefined(acc.sfaip_fsc_dw__DW_Accounts__r)){
                    var noAccountMsg = component.find('noAccountMsg');
                    $A.util.removeClass(noAccountMsg, 'slds-hide');
                    $A.util.addClass(noAccountMsg, 'slds-show');
                }else{
                    $A.util.addClass(noAccountMsg, 'slds-hide');
                    $A.util.removeClass(noAccountMsg, 'slds-show');
                }
            }
        });
        /**/
    },
    createMarketOrder: function(component, event, helper){
        var evt = component.getEvent('EvtInstrumentInfo') ;
        evt.setParams({
            "instrumentID": '459ce368-8f88-4fe1-8edb-d71c78af51f1',
            "instrumentName": 'Salesforce.com, Inc',
            "instrumentUrl": 'http://www.salesforce.com/',
            "context": "DWCreateMarketOrder.cmp"
        });
        component.find('utils').log('Firing Event: ' + evt);
        evt.fire();
    },
    createMarketOrderSwitchIns: function(component, event, helper) {
        var evt = component.getEvent('EvtInstrumentInfo');
        evt.setParams({
            "instrumentID": 'a67422af-8504-43df-9e63-7361eb0bd99e',
            "instrumentName": 'AAPL, Inc',
            "context": "DWCreateMarketOrder.cmp"
        });
        component.find('utils').log('Firing Event: ' + evt);
        evt.fire();

        /*
         var appEvent = $A.get("e.c:uiModalShowEvent");
         appEvent.setParams({
         title: 'Create Market Order',
         componentName: 'c:DWCreateMarketOrderForm',
         componentParams: {
         instrumentName: component.get('v.instrumentName'),
         instrumentID: component.get('v.instrumentID'),
         acc: component.get('v.acc')
         }

         });
         appEvent.fire();
         /**/
    },
    handleEvtInstrumentInfo: function(component, event, helper) {
        component.find('utils').log('Handling Event: ' + event);

        component.set('v.instrumentID', event.getParam("instrumentID"));
        component.set('v.instrumentName', event.getParam("instrumentName"));
        component.set('v.instrumentUrl', event.getParam("instrumentUrl"));
        component.set('v.instrumentInfoSet', true);

    }
    /*,
    test: function(component, event, helper) {
        var appEvent = $A.get("e.c:uiModalShowEvent");
        appEvent.setParams({
            title: 'Create Market Order',
            componentName: 'c:DWCreateMarketOrderForm',
            componentParams: {
                instrumentName: component.get('v.instrumentName'),
                instrumentID: component.get('v.instrumentID'),
                acc: component.get('v.acc')
            }

        });
        appEvent.fire();
    }
    */

})