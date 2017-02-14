/**
  * Controller class for Create Order (Practice or Live)
 */

public with sharing class DWCreateOrder_Controller  extends ETLC_ApexBridge_Abstract {
    /**
     * Method implementation for method in abstract class ETLC_ApexBridge_Abstract
     *
     * This is where we will process user input and decide which functions to call and return required output
     *
     * @param ETLC_ApexBridge_Data Data sent by lightning component
     */
    public override void process(ETLC_ApexBridge_Data data) {
        //Set debugging
        if (data.debug){
            Util.debug = data.debug;
        }

        // Depending on the mode, determine which operation to perform
        String mode = (String) data.getInputValue('mode');
        if (mode == 'getAccount') {
            data.output = ETLC_ApexBridge_Data.encodeData(getAccount((Id)data.getInputValue('AccountID')));
        }else if (mode == 'submitOrder') {
            Util.log('DWCreateOrder_Controller.process():data: ' + data);
            Util.log(data.getInputValue('acc'));
            data.output = ETLC_ApexBridge_Data.encodeData(submitOrder((Map<String, Object>)data.getInputValue('acc'), (Map<String, Object>)data.getInputValue('orderInfo')));
        }
    }

    /**
     * Retrieve account information based on Account ID
     *
     * @param ID Account ID for the record which we want to query
     *
     * @return Account
     */
    public static Account getAccount(ID AccountId) {
        Account retValue;
        try{
            retValue = DataQuery.getAccount(AccountId);
            Util.log('DriveWealth.retrieveDriveWealthSessionInfo():retValue: ' + retValue);
        }catch (SFDCAccessControlException e) {
            String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: ' + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: ' + e.getExceptionField() + ' Text: ' + e.getText();
            Util.log('DWCreateOrder_Controller.getDWAccountList():SFDCAccessControlException: ' + message);
        }catch(Exception e){ Util.log('DriveWealth.retrieveDriveWealthSessionInfo():Exception: ' + e.getMessage()); }
        return retValue;
    }

    /**
     * Process user information and submit to submit order
     *
     * 1) Process user data
     * 2) Query DWAccount to get upto date information (accountID, accountType, Account.userID etc); to ensure info is correct
     * 2) User submitted and queried information to Submit order
     * 3) Save to database in case of success
     *
     * @param Map<String, Object> Account information for order
     * @param Map<String, Object> Order information to submit for Market Order
     */
    public static Boolean submitOrder(Map<String, Object> acc, Map<String, Object> orderInfo) {
        Map<String, Object> orderInfoToPlaceOrder = new Map<String, Object>();
        orderInfoToPlaceOrder.put('accountID',acc.get('Id'));
        orderInfoToPlaceOrder.put('','');
        orderInfoToPlaceOrder.put('','');
        orderInfoToPlaceOrder.put('','');
        orderInfoToPlaceOrder.put('','');
        orderInfoToPlaceOrder.put('','');
        orderInfoToPlaceOrder.put('','');
        orderInfoToPlaceOrder.put('','');


                /*
                  "accountID":"02e57c7d-d071-4c63-b491-1194a9939ea5.1452548617456",
    "accountNo":"DWTE000005",
    "userID":"02e57c7d-d071-4c63-b491-1194a9939ea5",
    "accountType":2,
    "ordType":"1",
    "side":"B",
    "instrumentID":"06926627-e950-48f3-9c53-b679f61120ec",
    "orderQty":1.4312,
    "comment":""
                 */
        Util.log('orderInfo: ' + orderInfo);
        return true;
    }
}