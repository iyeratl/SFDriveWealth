({
    isValid: function(component, helper) {
        var message = Array(), retVal = true;

        var fname= component.get('v.fname');
        var lname = component.get('v.lname');
        var uname= component.get('v.uname');
        var passwd = component.get('v.passwd');



        //If account is not selected then show an error
            if($A.util.isEmpty(fname)) {
            message.push(
                ["ui:message", {
                    'severity': 'error',
                    'body': 'Please select an First Name'
                }]
            );
        }

        if(lname ==''){
            message.push(
                ["ui:message", {
                    'severity': 'error',
                    'body': 'Please select an Last Name'
                }]
            );
        }
        if(uname==''){
            message.push(
                ["ui:message", {
                    'severity': 'error',
                    'body': 'Please select an User Name'
                }]
            );
        }
        if( passwd == ''){
            message.push(
                ["ui:message", {
                    'severity': 'error',
                    'body': 'Please select a Password'
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
    fireEvtAccountCreated: function(component, helper) {
        var data = component.get('v.acc');

        var appEvent = $A.get("e.c:EvtAccountCreated");
        appEvent.setParams({
            "account": data,
            "context": "DWCreateAccountform.cmp"
        });

        component.find('utils').log('Firing EvtAccountCreated Event: ' + appEvent);

        appEvent.fire();
    },
    createAccount: function(component, helper) {
        if(helper.isValid(component, helper) && component.isValid()) {

            component.find('utils').toggleSpinner(component.find('spinner'), true);

            var apexBridge = component.find("ApexBridge");

            apexBridge.callApex({
                component: component,
                data: {
                    operation: "DWCreateAccount",
                    input: {
                        acc: component.get('v.acc'),
                        FirstName: component.get('v.fname'),
                        LastName: component.get('v.lname'),
                        UserName: component.get('v.uname'),
                        Password: component.get('v.passwd'),
                        mode: 'createAccount'
                    }
                },
                callBackMethod: function (data) {
                    component.find('utils').log('createAccount.data: ', data);
                    var data = data.output;

                    var message = Array();

                    if(data != null){
                        message.push(
                            ["ui:message", {
                                'severity': 'error',
                                'body': 'Some error occured while creating DriveWealth Account: ' + data.message
                            }]
                        );
                    }else{
                        var message = Array();
                        message.push(
                            ["ui:message", {
                                'severity': 'success',
                                'body': 'Account was successfully created'
                            }]
                        );
                        component.set('v.acc', data);

                        $A.util.addClass(component.find('createAccountForm'), 'slds-hide');

                        //Fire event to indicate that order has been created
                      helper.fireEvtAccountCreated(component, helper);
                    }
                    component.find('utils').createComponents(message, component.find('uiMessage'));

                    component.find('utils').toggleSpinner(component.find('spinner'), false);

                }
            });
        }
        /**/
    }
})