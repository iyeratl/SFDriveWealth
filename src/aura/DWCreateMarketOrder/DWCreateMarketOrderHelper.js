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

                var noAccountMsg = component.find('noAccountMsg');
                if($A.util.isUndefined(acc.sfaip_fsc_dw__DW_Accounts__r)){
                    $A.util.removeClass(noAccountMsg, 'slds-hide');
                    $A.util.addClass(noAccountMsg, 'slds-show');
                }else{
                    $A.util.addClass(noAccountMsg, 'slds-hide');
                    $A.util.removeClass(noAccountMsg, 'slds-show');

                    //Show Search Symbol Form
                    helper.showSearchSymbolForm(component, helper);

                    //Hide/Destroy market order form
                    helper.hideCreateMarketOrderForm(component, helper);
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

        //TODO: Workaround for strange bug where related records are not loaded the first time
        //https://org62.lightning.force.com/one/one.app#/sObject/0D50M000032hJOwSAM/view
        var acc = component.get('v.acc');
        //TODO: Remove above

        cmpArr.push(
            ["c:DWCreateMarketOrderForm",
                {
                    debug: component.get('v.debug'),
                    debugClient: component.get('v.debugClient'),
                    instrument: component.get('v.instrument'),
                    acc: component.get('v.acc'),
                    //TODO: Workaround for strange bug where related records are not loaded the first time
                    //https://org62.lightning.force.com/one/one.app#/sObject/0D50M000032hJOwSAM/view
                    dwAccRecords: acc.sfaip_fsc_dw__DW_Accounts__r.records
                    //TODO: Remove Above
                }
            ]
        );

        component.find('utils').log('cmpArr:', cmpArr) ;
        component.find('utils').createComponents(cmpArr, component.find('createMarketOrderForm'));
    },
    hideCreateMarketOrderForm: function(component, helper) {
        component.find('utils').destroyComponents(component.find('createMarketOrderForm'));
    }
})