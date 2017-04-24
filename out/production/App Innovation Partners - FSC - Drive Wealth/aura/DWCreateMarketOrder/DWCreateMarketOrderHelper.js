({
    getAccountInfo: function(component, helper){
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
                    //Show Search Symbol Form
                    helper.showSearchSymbolForm(component, helper);

                    $A.util.addClass(noAccountMsg, 'slds-hide');
                    $A.util.removeClass(noAccountMsg, 'slds-show');
                }
            }
        });
    },
    showSearchSymbolForm: function(component, helper) {
        //<c:DWSearchInstrument debug="{!v.debug}" debugClient="{!v.debugClient}" recordId="{!v.recordId}" fireEvtInstrumentInfo="true" showHeader="false"/>

        var cmpArr = Array();
        cmpArr.push(
            ["c:DWSearchInstrument",
                {
                    debug: component.get('v.debug'),
                    debugClient: component.get('v.debugClient'),
                    recordId: component.get('v.recordId'),
                    fireEvtInstrumentInfo: true,
                    showHeader: false
                }
            ]
        );

        component.find('utils').createComponents(cmpArr, component.find('searchSymbol'));

        //Reset instrument data to search again
        component.set('v.instrument', null);
    },
    hideSearchSymbolForm: function(component, helper) {
        component.find('utils').destroyComponents(component.find('searchSymbol'));
    },
    showCreateMarketOrderForm: function(component, helper) {
        //<c:DWCreateMarketOrderForm acc="{!v.acc}" instrument="{!v.instrument}" debug="{!v.debug}" debugClient="{!v.debugClient}" />
        var cmpArr = Array();
        cmpArr.push(
            ["c:DWCreateMarketOrderForm",
                {
                    debug: component.get('v.debug'),
                    debugClient: component.get('v.debugClient'),
                    instrument: component.get('v.instrument'),
                    acc: component.get('v.acc')
                }
            ]
        );
        console.log('cmpArr', cmpArr);
        component.find('utils').createComponents(cmpArr, component.find('createMarketOrderForm'));

    },
    hideCreateMarketOrderForm: function(component, helper) {
        component.find('utils').destroyComponents(component.find('createMarketOrderForm'));
    }
})