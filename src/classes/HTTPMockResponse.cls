@isTest
global class HTTPMockResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        // Optionally, only send a mock response for a specific endpoint
        // and method.

        if(req.getEndpoint() == 'http://api.drivewealth.io/v1/userSessions' && req.getMethod() == 'POST'){
            res = createSession();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/userSessionsINVALID' && req.getMethod() == 'POST'){
            res = createSession_invalid();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/userSessions/sessionKey' && req.getMethod() == 'GET'){
            res = getSession();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/userSessions/sessionKeyINVALID' && req.getMethod() == 'GET'){
            res = getSession_invalid();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/instruments?symbol=crm' && req.getMethod() == 'GET'){
            res = searchInstrument();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/instruments?symbol=crmINVALID' && req.getMethod() == 'GET'){
            res = searchInstrument_unauthorized();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/instruments?symbol=crmEMPTY' && req.getMethod() == 'GET'){
            res = searchInstrument_empty();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/instruments?symbols=crm,AAPL' && req.getMethod() == 'GET'){
            res = searchInstrument_multiple();
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/signups/practice' && req.getMethod() == 'POST'){
            //Need to mimic 401
            if(req.getHeader('x-mysolomeo-session-key') != null && req.getHeader('x-mysolomeo-session-key') == 'sessKey401'){
                res = createPracticeAccount401();

            }else{
                res = createPracticeAccount();
            }
        }else if(req.getEndpoint() == 'http://api.drivewealth.io/v1/orders' && req.getMethod() == 'POST') {
            res = createMarketOrder_positive();
        }

    return res;

    }

    /**
     * Create method to return Login data when POST is done for /sessions
     */
    private static HTTPResponse createSession(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"appTypeID": 2000,"commissionRate": 2.99,"loginState": 1,"referralCode": "VL7FN4","sessionKey": "02e57c7d-d071-4c63-b491-1194a9939ea5.2016-01-20T20:50:48.680Z","userID": "02e57c7d-d071-4c63-b491-1194a9939ea5","wlpID": "DW"}');
        res.setStatusCode(200);
        return res;
    }
    /**
     * Create method to return Login data when POST is done for /sessions
     */
    private static HTTPResponse createSession_invalid(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"code": 404,"message": "Username and Password do not match.  Please try again."}');
        res.setStatusCode(404);
        return res;
    }
    /**
     * getSessin to check invalid session
     */
    private static HTTPResponse getSession(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"appTypeID": 2000,"commissionRate": 2.99,"loginState": 1,"referralCode": "VL7FN4","sessionKey": "02e57c7d-d071-4c63-b491-1194a9939ea5.2016-01-20T20:50:48.680Z","userID": "02e57c7d-d071-4c63-b491-1194a9939ea5","wlpID": "DW"}');
        res.setStatusCode(200);
        return res;
    }
    /**
     * getSessin to check invalid session
     */
    private static HTTPResponse getSession_invalid(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"code": 401,"message": "Invalid x-mysolomeo-session-key HTTP header [ipAddress=204.14.239.82]"}');
        res.setStatusCode(401);
        return res;
    }
    /**
     * searchInstrument to search for intrument
     * http://developer.drivewealth.com/docs/search-instruments
     */
    private static HTTPResponse searchInstrument(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"instrumentID": "a67422af-8504-43df-9e63-7361eb0bd99e","name": "Apple, Inc.","category": "Stock","currencyID": "USD","exchangeID": "XNAS","limitStatus": 0}]');
        res.setStatusCode(200);
        return res;
    }
    /**
     * searchInstrument to search for intrument
     * http://developer.drivewealth.com/docs/search-instruments
     */
    private static HTTPResponse searchInstrument_unauthorized(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"code": 401,"message": "Invalid x-mysolomeo-session-key HTTP header [ipAddress=204.14.239.82]"}');
        res.setStatusCode(401);
        return res;
    }/**
     * searchInstrument to search for intrument
     * http://developer.drivewealth.com/docs/search-instruments
     */
    private static HTTPResponse searchInstrument_empty(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[]');
        res.setStatusCode(200);
        return res;
    }
    /**
     * searchInstrument to search for intrument
     * http://developer.drivewealth.com/docs/search-instruments
     */
    private static HTTPResponse searchInstrument_multiple(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"instrumentID": "a67422af-8504-43df-9e63-7361eb0bd99e","name": "Apple, Inc.","category": "Stock","currencyID": "USD","exchangeID": "XNAS","limitStatus": 0},{"instrumentID": "a67422af-8504-43df-9e63-7361eb0bd99e","name": "Apple, Inc.","category": "Stock","currencyID": "USD","exchangeID": "XNAS","limitStatus": 0}]');
        res.setStatusCode(200);
        return res;
    }

    /**
     * Create Practice Account
     * http://developer.drivewealth.com/docs/create-practice-account
     */
    private static HTTPResponse createPracticeAccount(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"password": "abcd1234","userID": "02e57c7d-d071-4c63-b491-1194a9939ea5","username": "bob227"}');
        res.setStatusCode(200);
        return res;
    }


    /**
     * Create Practice Account
     * http://developer.drivewealth.com/docs/create-practice-account
     */
    private static HTTPResponse createPracticeAccount401(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"code": "401","message": "Invalid x-mysolomeo-session-key HTTP header [ipAddress=1.1.1.1]"}');
        res.setStatusCode(401);
        return res;
    }

    /**
     * createMarketOrder Mock response
     * http://developer.drivewealth.com/docs/add-market-order
     */
    private static HTTPResponse createMarketOrder_positive(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"orderID": "DB.f88c392e-4d0a-4893-9623-baf72ac0296a","instrumentID": "06926627-e950-48f3-9c53-b679f61120ec","leavesQty": 1.4312,"ordType": "1","side": "B","limitPrice": 0,"timeInForce": "0","expireTimestamp": "2016-02-08T21:00:00.000Z","statusPath": "/v1/orders/DB.f88c392e-4d0a-4893-9623-baf72ac0296a"}');
        res.setStatusCode(200);
        return res;
    }
}