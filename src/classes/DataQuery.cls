/**
  * Class to build all the queries that we will be using
  * This is helpful as we will only need to keep all SOQL queries in one place in case we need to add/remove columns
  *
  * This class will also take care of CRUD/FLS as needed
 */
public with sharing class DataQuery {

    /**
      * Return DriveWealth Account List created for an Account based on Account ID
      *
      *
      * Note: Use try/catch in calling function to trap any Exceptions
      * This funciton can raise SFDCAccessControlException or Eception
      *
      * @param AccountID ID of account
      *
      * @return Account
     */

    public static Account getAccount(Id AccountId){

        //CRUD/FLS check
        Boolean hasAccountViewPermission = Util.AccessController.isAuthorizedToView(
            Schema.Account.getSobjectType(),
            new List<Schema.SobjectField>{
                    Schema.Account.fields.Name
            }
        );

        Boolean hasDWAccountViewPermission = Util.AccessController.isAuthorizedToView(
                Schema.DW_Account__c.getSobjectType(),
                new List<Schema.SobjectField>{
                        Schema.DW_Account__c.fields.Name
                }
        );

        Account a;
        List<Account> listAcc =  [select ID, Name, (select Id, Name from DW_Accounts__r) from Account WHERE Id=:AccountId];
        if(listAcc.size() > 0 ){
            a = listAcc[0];
        }
        return a;
    }
    /**
      * Return DriveWealth Account information created for an Account based on DW Account ID
      *
      * Note: Use try/catch in calling function to trap any Exceptions
      * This funciton can raise SFDCAccessControlException or Eception
      *
      * @param AccountID ID of account
      *
      * @return DW_Account__c
     */

    public static DW_Account__c getDWAccount(Id DWAccountID){

        //CRUD/FLS check
        //Chek for DW Account
        Boolean hasDWAccountViewPermission = Util.AccessController.isAuthorizedToView(
                Schema.DW_Account__c.getSobjectType(),
                new List<Schema.SobjectField>{
                        Schema.DW_Account__c.fields.Name, Schema.DW_Account__c.fields.Account__c,
                        Schema.DW_Account__c.fields.Account_ID__c, Schema.DW_Account__c.fields.Account_No__c,
                        Schema.DW_Account__c.fields.Account_Type__c
                }
        );
        //Check for account as we also need it for that
        Boolean hasAccountViewPermission = Util.AccessController.isAuthorizedToView(
                Schema.Account.getSobjectType(),
                new List<Schema.SobjectField>{
                        Schema.Account.fields.Name, Schema.Account.fields.DW_User_ID__c,
                        Schema.Account.fields.DW_Username__c, Schema.Account.fields.DW_Password__c
                }
        );
        return [select ID,Name,Account__c,Account_ID__c, Account_No__c, Account_Type__c, Account__r.DW_User_ID__c,
                        Account__r.DW_Username__c, Account__r.dW_Password__c
                    from DW_Account__c WHERE Id=:DWAccountID];
    }

}