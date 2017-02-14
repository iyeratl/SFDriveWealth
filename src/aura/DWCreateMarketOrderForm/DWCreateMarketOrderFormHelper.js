({
    isValid: function(component, helper) {
        var message = Array(), retVal = true;



        //If account is not selected then show an error
        var accountID = component.find('accountID');
        if( (accountID.get('v.validity') != null && accountID.get('v.validity').valueMissing)  || accountID.get('v.value') == ''){
            message.push(
                ["ui:message", {
                    'severity': 'error',
                    'body': 'Please select an Account'
                }]
            );
        }


        //Check if order quantity has been added and >0
        var orderQty = component.find('orderQty');
        if( (orderQty.get('v.validity') != null && orderQty.get('v.validity').valueMissing)  || orderQty.get('v.value')<=0) {
            message.push(
                ["ui:message", {
                    'severity': 'error',
                    'body': 'Please enter a value >0 for Order Quantity'
                }]
            );
        }

        if(message.length > 0){
            //Create new components through utility method
            component.find('utils').createComponents(message, component.find('uiMessage'));
            retVal = false;
        }else{
            //Destroy previous components to clear out messages
            component.find('utils').destroyComponents(component.find('uiMessage'));
        }

        return retVal;
    },
    submitOrder: function(component, helper) {
        if(helper.isValid(component, helper) && component.isValid()) {
            var apexBridge = component.find("ApexBridge");
            apexBridge.callApex({
                component: component,
                data: {
                    operation: "DWCreateOrder_Controller",
                    input: {
                        acc: component.get('v.acc'),
                        orderInfo: component.get('v.dworder'),
                        mode: 'submitOrder'
                    }
                },
                callBackMethod: function (data) {
                    component.find('utils').log('submitOrder.data: ');
                    component.find('utils').log(data);
                    var isComplete = data.output;

                }
            });
        }
        /**/
    }
})