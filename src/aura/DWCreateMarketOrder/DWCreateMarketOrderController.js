({
    doInit : function(component, event, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            data: {
                operation: "DWCreateOrder_Controller",
                input: {
                    AccountID: component.get('v.AccountID'),
                    mode: 'getAccount'
                }
            },
            callBackMethod: function (data) {
                var acc = data.output;
                component.set('v.acc', acc);
            }
        });
    },
    createMarketOrder: function(component, event, helper){

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
    }
})