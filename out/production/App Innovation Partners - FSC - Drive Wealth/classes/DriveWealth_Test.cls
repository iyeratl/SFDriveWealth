@isTest
private class DriveWealth_Test {

    @testSetup
    private static void dataSetup(){
        DriveWealth__c dw = new DriveWealth__c();
        dw.endpoint__c = 'http://api.drivewealth.io/v1/';
        insert dw;

        List<Account> listAcc = new List<Account>();
        for(Integer i=0;i<300; i++){
            Account acc = new Account();
            acc.Name = 'Account A' + i;
            acc.DW_Username__c = 'abc1234';
            acc.DW_Password__c = 'abc1234';

            //This ID matches the data from HTTPMockResponse in createSession()
            acc.DW_User_ID__c = '02e57c7d-d071-4c63-b491-1194a9939ea5';

            listAcc.add(acc);
        }

        insert listAcc;

    }

    /**
     * Shoudl return proper code because,w ith invalid session, it should do login again
     */


    @isTest
    private static void login_withActiveSessionButWrongKeyName_pass() {
        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];


        DW_Session__c dws = new DW_Session__c();

        dws.Active__c = true;
        dws.Name = userInfo.getUserId();
        //Need to use sessionKey to generate proper session URL so using wrong one here
        //This will ensure that login is triggered
        dws.DW_Session_Key__c = 'sessionKeyINVALID';
        dws.DW_User_ID__c = '02e57c7d-d071-4c63-b491-1194a9939ea5';
        dws.Account__c = acc.Id;
        insert dws;


        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        DriveWealthJsonSession res = DriveWealth.doSetup(acc.Id);
        DriveWealth.doCleanup();
        Test.stopTest();


        System.assertEquals(null, res.code);
        System.assertEquals(2000, res.appTypeID);

    }

    @istest
    private static void doSetup(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.startTest();
        DriveWealth.doSetup(acc.Id);
        Test.stopTest();

        System.assertEquals(false, DriveWealth.dws.Active__c);

    }
    @istest
    private static void doCleanup(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.startTest();
        DriveWealth.doSetup(acc.Id);
        DriveWealth.doCleanup();
        Test.stopTest();

        System.assertEquals(true, DriveWealth.dws.Active__c);

    }
    @isTest
    private static void login_positive(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];


        Test.startTest();
        DriveWealthJsonSession res = DriveWealth.doSetup(acc.Id);
        DriveWealth.doCleanup();
        Test.stopTest();

        System.assertEquals(2000, res.appTypeID);

        List<DW_Session__c> dwsList = [select Id, Active__c from DW_Session__c];
        System.assertEquals(1, dwsList.size());
    }

    @isTest
    private static void searchInstrument_positive(){
        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        DriveWealth.doSetup(acc.Id);
        List<DriveWealthJsonInstrument> res = DriveWealth.searchInstrument('crm');
        DriveWealth.doCleanup();
        Test.stopTest();

        System.assertEquals('a67422af-8504-43df-9e63-7361eb0bd99e', res[0].instrumentID);
    }
    @isTest
    private static void searchInstrument_negative(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        List<DriveWealthJsonInstrument> res = DriveWealth.searchInstrument('crmINVALID');
        Test.stopTest();

        System.assertEquals(0, res.size());
    }
    @isTest
    private static void searchInstrument_empty(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        List<DriveWealthJsonInstrument> res = DriveWealth.searchInstrument('crmEMPTY');
        Test.stopTest();

        System.assertEquals(0, res.size());
    }
    @isTest
    private static void createAccount_newuser_positive(){
        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        //Data for Practice Account Creation
        Map<String, Object> data = new Map<String, Object> ();
        data.put('emailAddress1', 'test@test.com2');//Pull from Account
        data.put('firstName', 'FirstName 2');//Pull from Account
        data.put('lastName', 'LastName 2');//Pull from Account
        data.put('referralCode', 'Temp Code');
        //If new account then provide username/password
        data.put('username', 'abc1234');
        data.put('password', 'abc1234');


        Test.startTest();
        DriveWealth.doSetup(acc.Id);
        DriveWealthJsonAccount res = DriveWealth.createPracticeAccount(data);
        DriveWealth.doCleanup();
        Test.stopTest();

        System.assertEquals('02e57c7d-d071-4c63-b491-1194a9939ea5', res.userID);
    }


    @isTest
    private static void createAccount_existinguser_positive(){
        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        //Data for Practice Account Creation
        Map<String, Object> data = new Map<String, Object> ();
        data.put('emailAddress1', 'test@test.com2');//Pull from Account
        data.put('firstName', 'FirstName 2');//Pull from Account
        data.put('lastName', 'LastName 2');//Pull from Account
        data.put('referralCode', 'Temp Code');
        //If existing user then provide user id
        data.put('userID', userInfo.getUserID());


        Test.startTest();
        DriveWealth.doSetup(acc.Id);
        DriveWealthJsonAccount res = DriveWealth.createPracticeAccount(data);
        DriveWealth.doCleanup();
        Test.stopTest();

        System.assertEquals('02e57c7d-d071-4c63-b491-1194a9939ea5', res.userID) ;
    }

    @isTest
    private static void createAccount_failure_401(){
        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        //Data for Practice Account Creation
        Map<String, Object> data = new Map<String, Object> ();
        data.put('emailAddress1', 'test@test.com2');//Pull from Account
        data.put('firstName', 'FirstName 2');//Pull from Account
        data.put('lastName', 'LastName 2');//Pull from Account
        data.put('referralCode', 'Temp Code');
        //If new account then provide username/password
        //If existing user then provide user id
        //This will also add session key in request that we can use to see 401 error
        data.put('userID', userInfo.getUserID());


        Test.startTest();
        DriveWealth.doSetup(acc.Id);

        //This will be used in HTTPMockResponse class to send 401 response for testing
        DriveWealth.dws.DW_Session_Key__c = 'sessKey401';

        DriveWealthJsonAccount res = DriveWealth.createPracticeAccount(data);
        DriveWealth.doCleanup();
        Test.stopTest();

        System.assertEquals(401, res.code);
    }
    /**/
}