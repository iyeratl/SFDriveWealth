public with sharing class DWCreateAccount {
    public DWCreateAccount() {
    //Set this if you need to see debug statements
            Util.debug = true;

            //If there is no DW User ID" AND/OR "DW Account ID" associate with (standard) Account
            //Then create new Practice account
            //Hint: Use SOQL or initial data load to get this informaiton in, say, Lightning Component
            String AccountID = '00141000007RP8w';
            Account a = DataQuery.getAccount(AccountId);

            //If no DW Accounts then create one
            if(a.DW_Total_Practice_Accounts__c <= 0 ){
                //Custom setting to get "referralCode" needed to create account
                DriveWealth__c dw = DriveWealth__c.getInstance() ;

                String username = a.AccountNumber; //'sfusername';
                String password = a.AccountNumber; //'sfpassword';

                //Data for Practice Account Creation
                Map<String, String> data = new Map<String, String> ();
                data.put('emailAddress1', 'test@test.com2');//Pull from Account
                data.put('firstName', 'FirstName 2');//Pull from Account
                data.put('lastName', 'LastName 2');//Pull from Account
                data.put('referralCode', dw.Referral_Code__c);
                //If new account then provide username/password
                data.put('username', username);
                data.put('password', password);

                System.debug(data);

                //There is no setup because we want to use new username info for login
                DriveWealthJsonAccount aInfo = DriveWealth.createPracticeAccount(data);

                //Now login with new username/password to start session and get account info
                DriveWealthJsonSession sessionInfo = DriveWealth.doSetup(a);


                //userID as returned after creating user
                String DWUserID = aInfo.userID;

                //Update account with new userID and username and password
                a.DW_Username__c = username;
                a.DW_Password__c = password;
                a.DW_User_ID__c = sessionInfo.userID;

                //Update account with new username, password and user I
                update a;


                //Go through entire list of accounts returned for that user and update the list
                //This will return newly created account if user is new.
                //But will also return account for old user
                List<DW_Account__c> listAcc = new List<DW_Account__c>();
                for(Integer i=0; i<sessionInfo.Accounts.size(); i++){
                    DW_Account__c acc = new DW_Account__c();
                    acc.name = sessionInfo.Accounts[i].nickname;
                    acc.Account__c = a.Id;
                    acc.Account_ID__c = sessionInfo.Accounts[i].accountID;
                    acc.Account_No__c = sessionInfo.Accounts[i].accountNo;
                    acc.Account_Type__c = sessionInfo.Accounts[i].accountType;
                    acc.Created_When__c = sessionInfo.Accounts[i].createdWhen;
                    acc.Opened_When__c = sessionInfo.Accounts[i].openedWhen;

                    listAcc.add(acc);
                }
                //Upsert all accounts using Account_ID__c as External key so that it's unique
                upsert listAcc Account_ID__c;
                System.debug(listAcc);

                //Update new session Info from DriveWealth
                DriveWealth.doCleanup();

            }else{

            }


            List<DW_Account__c> listDWAcc = [select Account_ID__c, Account__r.Id,
                                                    Account__r.AccountNumber, Account__r.DW_User_ID__c
                                                from DW_Account__c
                                                where Account__r.Id=:AccountID];
            //listDWAcc can be returned for use
            System.debug(listDWAcc);
        
    }
}