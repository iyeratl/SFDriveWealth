/**
  * Controller class for Create Order (Practice or Live)
 */

public with sharing class DWSearchInstrument_Controller  extends ETLC_ApexBridge_Abstract {
    /**
     * Method implementation for method in abstract class ETLC_ApexBridge_Abstract
     *
     * This is where we will process user input and decide which functions to call and return required output
     *
     * @param ETLC_ApexBridge_Data Data sent by lightning component
     */
    public override void process(ETLC_ApexBridge_Data data) {
        System.debug('DWSearchInstrument_Controller.process():data: ' + data);
        //Set debugging
        if (data.debug) {
            Util.debug = data.debug;
        }

        // Depending on the mode, determine which operation to perform
        String mode = (String) data.getInputValue('mode');
        if (mode == 'searchInstrument') {
            data.output = ETLC_ApexBridge_Data.encodeData(searchInstrument((Id)data.getInputValue('AccountID'), (String) data.getInputValue('symbol')));
        } else if (mode == 'submitOrder') {
        }
    }

    private List<DriveWealthJsonInstrument> searchInstrument(Id AccountID, String symbol){

        List<DriveWealthJsonInstrument> retVal = new List<DriveWealthJsonInstrument>();
        try {
            Util.log('DWSearchInstrument_Controller.searchInstrument():symbol: ' + symbol);
            Util.log('DWSearchInstrument_Controller.searchInstrument():AccountID: ' + AccountID);
            //Need to login to DriveWealth
            //User "generic" username/password from Custom Settings
            DriveWealthJsonSession sessionInfo = DriveWealth.doSetup(AccountID);
            if(sessionInfo != null) {
                retVal = DriveWealth.searchInstrument(symbol);
                //Update new session Info from DriveWealth
                DriveWealth.doCleanup();

                Util.log('DWSearchInstrument_Controller.searchInstrument().retVal: ' + retVal);

            }
        }catch(Exception e){ Util.log('DWSearchInstrument_Controller.searchInstrument():Exception: ' + e.getMessage()); }

        return retVal;
    }
}