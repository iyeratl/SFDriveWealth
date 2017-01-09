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

            listAcc.add(acc);
        }

        insert listAcc;
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
    @istest
    private static void doSetup_existing(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Account acc = [SELECT Id, DW_Username__c, DW_Password__C from Account where name='Account A0' limit 1];

        Test.startTest();
        DriveWealth.doSetup(acc.Id);
        DriveWealth.doCleanup();
        //Test for preexisting setup
        DriveWealth.doSetup(acc.Id);
        Test.stopTest();

        System.assertEquals(true, DriveWealth.dws.Active__c);

    }
    /*
    @isTest
    private static void login_positive(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        DriveWealthJsonSession res = DriveWealth.login();
        Test.stopTest();

        System.assertEquals(2000, res.appTypeID);

        List<DriveWealthSession__c> dwsList = [select Id, Active__c from DriveWealthSession__c];
        System.assertEquals(1, dwsList.size());
    }

    @isTest
    private static void login_withActiveSession_positive(){
        DriveWealthSession__c dws = new DriveWealthSession__c();

        dws.Active__c = true;
        dws.Name = userInfo.getUserId();
        dws.SFSessionId__c = UserInfo.getSessionId();
        dws.DWSessionKey__c = 'sessionKey'; //Need to use sessionKey to generate proper session URL
        insert dws;

        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        DriveWealthJsonSession res = DriveWealth.login();
        Test.stopTest();

        System.assertEquals(2000, res.appTypeID);

        String sessionKey = '02e57c7d-d071-4c63-b491-1194a9939ea5.2016-01-20T20:50:48.680Z';
        List<DriveWealthSession__c> dwsList = [select Id, DWSessionKey__c from DriveWealthSession__c];
        System.assertEquals(sessionKey, dwsList[0].DWSessionKey__c);

    }
    @isTest
    private static void login_withActiveSessionButWrongKeyName_positive(){
        DriveWealthSession__c dws = new DriveWealthSession__c();

        dws.Active__c = true;
        dws.Name = userInfo.getUserId();
        dws.SFSessionId__c = UserInfo.getSessionId();
        //Need to use sessionKey to generate proper session URL so using wrong one here
        //This will ensure that login is triggered
        dws.DWSessionKey__c = 'sessionKeyINVALID';
        insert dws;

        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        DriveWealthJsonSession res = DriveWealth.login();
        Test.stopTest();

        System.assertEquals(2000, res.appTypeID);

        String sessionKey = '02e57c7d-d071-4c63-b491-1194a9939ea5.2016-01-20T20:50:48.680Z';
        List<DriveWealthSession__c> dwsList = [select Id, DWSessionKey__c from DriveWealthSession__c];
        System.assertEquals(sessionKey, dwsList[0].DWSessionKey__c);

    }

    @isTest
    private static void searchInstrument_positive(){
        Test.setMock(HTTPCalloutMock.class, new HTTPMockResponse());

        Test.startTest();
        List<DriveWealthJsonInstrument> res = DriveWealth.searchInstrument('crm');
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
    /**/
}