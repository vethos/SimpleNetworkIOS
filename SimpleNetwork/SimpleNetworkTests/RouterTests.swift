//
//  RouterTests.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 16/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import XCTest
@testable import SimpleNetwork

class RouterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRouter() {
        let getRouter = MocksRouter(call: .get)
        let router = getRouter.router
        let request = try! router.asURLRequest()
        
        XCTAssertNotNil(router.apiParams)
        XCTAssertNotNil(router.delegate)
        
        XCTAssertEqual(request.httpMethod!, "GET")
        XCTAssertEqual(request.url!.absoluteString, "https://http://httpbin.org/get".urlEncoded)
        XCTAssertEqual(request.timeoutInterval, Router.defaultTimeoutInterval)
       
        let headers = request.allHTTPHeaderFields!
        let expectedHeaders = [
            HttpHeader.timeZone.key,
            HttpHeader.appVersion(version: "1.0").key,
            HttpHeader.authorization(token: "mock").key
        ]
        
        //test http headers
        XCTAssertEqual(headers.count, expectedHeaders.count)
        for (key, _) in headers {
            XCTAssertTrue(expectedHeaders.contains(key))
        }
    }
    
    
}

/*
 //test api params
 //        XCTAssertEqual(router.call, .get)
 //        XCTAssertEqual(router.url(), "https://http://httpbin.org/get")
 //        XCTAssertEqual(router.HTTPMethod(), .get)
 //        XCTAssertNil(router.parameters())
 //        XCTAssertEqual(router.timeoutInterval(), Router.defaultTimeoutInterval)
 //
 //        var urlRequest = URLRequest(url: URL(string: "mock.com")!)
 //        router.addHeaders(toRequest: &urlRequest)
 
 */
