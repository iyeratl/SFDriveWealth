/**
  * Controller class for Create Order (Practice or Live)
 */

public with sharing class DWCreateOrder_Controller  extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Data data) {
        //Set debugging
        if (data.debug){
            Util.debug = data.debug;
        }

        // Depending on the mode, determine which operation to perform
        String mode = (String) data.getInputValue('mode');
        if (mode == 'getAccount') {
            data.output = ETLC_ApexBridge_Data.encodeData(getAccount((Id)data.getInputValue('AccountID')));
        }
    }

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
}