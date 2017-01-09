/**
 * DriveWealth class is wrapper fto DriveWealthAPI
 * This class takes care of calling API methods, handling errors, dealing with database (for session) and more
 *
 * @author Jaswinder Rattanpal <jrattanpal@salesforce.com>
 */

public with sharing class DriveWealth {

    //DriveWealth custom settings for DWW Endpoint (and maybe other) information
    private static DriveWealth__c dw = DriveWealth__c.getInstance() ;

    /** Store account information for later user; if need */
    private static Account acc;

    /**
      * Get DriveWealth session information from DW_Session__c object
      * Name of a record for a session will show as "Account:DW_SESSION_KEY"
     */
    public static DW_Session__C dws;

    /**
     * Temporarialy store Login information to use during class execution
     */
    private static DriveWealthJsonSession sessionInfo;

    /**
     * Retrieve DriveWealth session information from DW_Session__c object
     * Record name matches with "Account:DW_SESSION_KEY" for each sesison because session key will be unique
     * This is becasue each Account will have a separate user account in DriveWealth
     *
     * If a record exists then return it to be checked for validatiy
     *
     * @param AccountID ID of account for which we are checking session
     * @param DWUserID ID of DW User account associated with salesforce Account
     *
     * @return DW_Session__C
     */
    private static DW_Session__C retrieveDWSessionInfo(String AccountID, String DWUserID){
        try{
            //CRUD/FLS check
            Boolean hasAccountViewPermission = Util.AccessController.isAuthorizedToView(
                    Schema.DW_Session__C.getSobjectType(),
                    new List<Schema.SobjectField>{
                            Schema.DW_Session__C.fields.Name, Schema.DW_Session__C.fields.Account_ID__c,
                            Schema.DW_Session__C.fields.DW_Session_Key__c, Schema.DW_Session__C.fields.DW_User_ID__c,
                            Schema.DW_Session__C.fields.Active__c
                    }
            );

               //Get record based on AccountID from DW_Session__c
            List<DW_Session__C> DWSession = [
                    select ID, Name, DW_Session_Key__c, DW_User_ID__c, Account_ID__c, Active__c
                    from DW_Session__c
                    where Account_ID__c = :AccountID and DW_User_ID__c=:DWUserID
                    limit 1
            ];

            if (DWSession.size() > 0) {
                dws = DWSession[0];
            }else{
                dws = new DW_Session__C();
                dws.Active__c = false;
                dws.Name = '';
                dws.DW_User_ID__c = '';
                dws.Account_ID__c = '';
                dws.DW_Session_Key__c = '';
                dws.ID = null;

            }
        }catch (SFDCAccessControlException e) {
            String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: '
                    + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: '
                    + e.getExceptionField() + ' Text: ' + e.getText();
            Util.log('DriveWealth.retrieveDriveWealthSessionInfo():Exception: ' + message);
        }catch(Exception e){ Util.log('DriveWealth.retrieveDriveWealthSessionInfo():Exception: ' + e.getMessage()); }
        return dws;
    }

     /**
     * Upset session information for an account with new session
     *
     *
     * @param AccountID Need to provide it explicitly as it's future method
     * @param DWUserID ID of DW User account associated with salesforce Account
     * @param DWSessionKey Session key returned after login call to DriveWealth
     *
     * @return Boolean
     */
    private static void setDWSessionInfo(String AccountID, String DWID, String DWUserID, String DWSessionKey){
        try{

            //CRUD/FLS check
            Boolean hasAccountCreatePermission = Util.AccessController.isAuthorizedToCreate(
                    Schema.DW_Session__C.getSobjectType(),
                    new List<Schema.SobjectField>{
                            Schema.DW_Session__C.fields.Name, Schema.DW_Session__C.fields.Account_ID__c,
                            Schema.DW_Session__C.fields.DW_Session_Key__c, Schema.DW_Session__C.fields.DW_User_ID__c,
                            Schema.DW_Session__C.fields.Active__c
                    }
            );
            Boolean hasAccountUpdatePermission = Util.AccessController.isAuthorizedToUpdate(
                    Schema.DW_Session__C.getSobjectType(),
                    new List<Schema.SobjectField>{
                            Schema.DW_Session__C.fields.Name, Schema.DW_Session__C.fields.Account_ID__c,
                            Schema.DW_Session__C.fields.DW_Session_Key__c, Schema.DW_Session__C.fields.DW_User_ID__c,
                            Schema.DW_Session__C.fields.Active__c
                    }
            );

            dws = new DW_Session__C();
            dws.Id = DWID;
            dws.Name = 'Account:' + AccountID;
            dws.Active__c = true;
            dws.DW_Session_Key__c = DWSessionKey;
            dws.Account_ID__c = AccountID;
            dws.DW_User_ID__c = DWUserID;
            upsert dws DW_User_ID__c;

            Util.log('DriveWealth.setDWSessionInfo():Upsert: ' + dws) ;

        }catch (SFDCAccessControlException e) {
            String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: '
                    + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: '
                    + e.getExceptionField() + ' Text: ' + e.getText();
            Util.log('DriveWealth.setDWSessionInfo():Exception: ' + message);
        }catch(Exception e){ Util.log('DriveWealth.setDWSessionInfo():Exception: ' + e.getMessage()); }
    }

    /**
     * Wrapper to login to DriveWealth
     *
     * First check if existing session is valid
     *
     * @param username DW Username
     * @param password DW Password
     *
     * @return DriveWealthJsonSession
     */
    public static DriveWealthJsonSession login(String username, String password){
        DriveWealthJsonSession retValue = null;

        try {
            //Check if valid SID exists in
            if (dws.Active__c == true) {
                retValue = DriveWealthAPI.getSession(DriveWealthAPI.getEndpointGetSession(dws.DW_Session_Key__c), dws.DW_Session_Key__c);
                Util.log('DriveWealth:login():getSession():retValue: ' + retValue);
            }
            //If Session is not valid then let's do new login
            //retValue.code might be 500 (wrong session format) or 401 (not valid); if NOT null then let's do login
            if (retValue == null || retValue.code != null) {

                retValue = DriveWealthAPI.createSession(DriveWealthAPI.getEndpointCreateSession(), username, password);
                Util.log('DriveWealth:login():createSession():retValue: ' + retValue);
            }
        }catch(Exception e){ Util.log('DriveWealth.login(username, password):Exception: ' + e.getMessage()); }
        return retValue;
    }
    /**
     * Retrieve account information and initialize variable
     *
     * @param AccountID ID for account to get information
     */

    private static void retrieveAccountInfo(String AccountID){
        try{

            //retrieve account information
            if(acc == null){
                //CRUD/FLS check
                Boolean hasAccountViewPermission = Util.AccessController.isAuthorizedToView(Schema.Account.getSobjectType(),
                    new List<Schema.SobjectField>{
                        Schema.Account.fields.Name, Schema.Account.fields.DW_Username__c,
                        Schema.Account.fields.DW_Password__c, Schema.Account.fields.DW_User_ID__c
                    }
                );

                List<Account> listAccounts = [select id, DW_Username__c, DW_Password__c, DW_User_ID__c FROM account where ID=:AccountID limit 1];
                if(listAccounts.size() > 0){
                    acc = listAccounts[0];
                }
            }
        }
        catch (SFDCAccessControlException e) {
            String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: '
                    + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: '
                    + e.getExceptionField() + ' Text: ' + e.getText();
            Util.log('DriveWealth.retrieveDriveWealthSessionInfo():Exception: ' + message);
        }catch(Exception e){ Util.log('DriveWealth.login(username, password):Exception: ' + e.getMessage()); }
    }
    /**
     * This is used to prepare information for login. We need Account ID as we need to get DriveWealth username/password and other information
     * This function will take care of preparing all that
     *
     * This method should be used before calling any function in this class. This will ensure that proper session is setup (only once) before proceeding
     *
     * @param AccountID ID of Account to retrieve information
     *
     * @return DriveWealthJsonSession
     */
    public static DriveWealthJsonSession doSetup(String AccountID){
        return doSetup(AccountID, null, null);
    }
    /**
     * Same as doSetup but this one takes explicit username/password in case we need to supply it directly and not from Account
     *
     * @param AccountID ID of Account to retrieve information
     * @param Username DW Username to login
     * @param Password DW Password to login
     */
    public static DriveWealthJsonSession doSetup(String AccountID, String Username, String Password){
        try {
            Util.log('DriveWealth:init():retrieveAccountInfo:AccountID: ' + AccountID);
            retrieveAccountInfo(AccountID);

            if(acc != null) {
                //Retrieve session information from object if it's there
                retrieveDWSessionInfo(AccountId, acc.DW_User_ID__c);
                Util.log('DriveWealth:init():retrieveDWSessionInfo:dws: ' + dws);

                if(dws != null) {
                    Username =  (Username == null)?acc.DW_Username__c:Username;
                    Password =  (Password == null)?acc.DW_Password__c:Password;

                    //Login to make sure session is valid
                    sessionInfo = login(username, password);
                    Util.log('DriveWealth:init():login:retValue: ' + sessionInfo);
                }
            }
        }catch(Exception e){ Util.log('DriveWealth.login(AccountID):Exception: ' + e.getMessage()); }
        return sessionInfo;
    }
    /**
     * This is to update session information. But we need to do it AFTER the callouts otherwise we will get following error
     *
     *
     * You have uncommitted work pending. Please commit or rollback before calling out
     *
     */
    public static void doCleanup(){
        try {
            if(dws != null && acc != null) {
                //Update DW Session to newest
                Util.log('DriveWealth:init():setDWSessionInfo:FutureHandler:acc ' + acc);
                Util.log('DriveWealth:init():setDWSessionInfo:FutureHandler:dws ' + dws);
                Util.log('DriveWealth:init():setDWSessionInfo:FutureHandler:sessionInfo ' + sessionInfo);
                setDWSessionInfo(acc.Id, dws.ID, sessionInfo.userID, sessionInfo.sessionKey);
            }
        }catch(Exception e){ Util.log('DriveWealth.login(AccountID):Exception: ' + e.getMessage()); }
    }


    /**
     * Search instrument, this is to get Stock Symbol information. This will later be used for orders
     *
     * Ensure that init() is called before this to make sure there is valid session
     *
     * <pre>
     *     //Need to login to DriveWealth
     *     DriveWealth.doSetup('00141000007RP8r');
     *     List<DriveWealthJsonInstrument> inInfo = DriveWealth.searchInstrument('CRM,AAPL');
     *     //Update new session Info from DriveWealth
     *     DriveWealth.doCleanup();
     * </pre>
     *
     * @param symbol One or more (comma separated) symbols; CRM OR CRM,AAPL
     *
     * @return DriveWealthJsonSession
     */
    public static List<DriveWealthJsonInstrument> searchInstrument(String symbol){
        List<DriveWealthJsonInstrument> retVal = new List<DriveWealthJsonInstrument>();
        try{
            retVal = DriveWealthAPI.searchInstrument(DriveWealthAPI.getEndpointSearchInstrument(symbol), dws.DW_Session_Key__c);
            //retVal might be null, in that case, login() again
        }catch(Exception e){ Util.log('DriveWealth.searchInstrument():Exception: ' + e.getMessage());  }

        return retVal;
    }

    /**
     * Create a Practice Account
     *
     * Ensure that init() is called before this to make sure there is valid session
     *
     * <pre>
     *     //Set this if you need to see debug statements
     *     //Util.debug = true;
     *
     *     //If there is no DW User ID" AND/OR "DW Account ID" associate with (standard) Account
     *     //Then create new Practice account
     *     //Hint: Use SOQL or initial data load to get this informaiton in, say, Lightning Component
     *
     *
     *     //Custom setting to get "referralCode" needed to create account
     *     DriveWealth__c dw = DriveWealth__c.getInstance() ;
     *
     *
     *      String username = 'sfusername';
     *      String password = 'sfpassword';
     *
     *     //Data for Practice Account Creation
     *     Map<String, String> data = new Map<String, String> ();
     *     data.put('emailAddress1', 'test@test.com');//Pull from Account
     *     data.put('firstName', 'FirstName');//Pull from Account
     *     data.put('lastName', 'LastName');//Pull from Account
     *     data.put('username', username);
     *     data.put('password', password);
     *     data.put('referralCode', dw.Referral_Code__c);
     *     System.debug(data);
     *
     *     //There is no setup because we want to use new username info for login
     *
     *     //Create practice account
     *     DriveWealthJsonAccount aInfo = DriveWealth.createPracticeAccount(data);
     *
     *     //userID as returned after creating user
     *     String DWUserID = aInfo.userID;
     *
     *     DriveWealthJsonSession sessionInfo = DriveWealth.doSetup('00141000007RP8r', username, password);
     *     String DWAccountID = sessionInfo.Accounts[0].accountID;
     *     System.debug(sessionInfo);
     *     System.debug(DWAccountID);
     *
     *     //Do DML here to store new username, password, DW User ID and DW Account ID in Account
     *     Account acc = [select id from account where id='00141000007RP8t'];
     *     acc.DW_Account_ID__c = DWAccountID;
     *     acc.DW_User_ID__c = DWUserID;
     *     acc.DW_Username__c = username;
     *     acc.DW_Password__c = password;
     *     update acc;
     *
     *     //Update new session Info from DriveWealth
     *     DriveWealth.doCleanup();
     * </pre>
     *
     * @param data Map of data to be sent to DriveWealth for creating practice account
     *
     * @return DriveWealthJsonAccount
     */
    public static DriveWealthJsonAccount createPracticeAccount(Map<String, String> data){
        DriveWealthJsonAccount retVal = new DriveWealthJsonAccount();
        try{

            retVal = DriveWealthAPI.createPracticeAccount(DriveWealthAPI.getEndpointCreatePracticeAccount(), data);

            //retVal might be null, in that case, login() again
        }catch(Exception e){ Util.log('DriveWealth.createPracticeAccount():Exception: ' + e.getMessage());  }

        return retVal ;
    }

}