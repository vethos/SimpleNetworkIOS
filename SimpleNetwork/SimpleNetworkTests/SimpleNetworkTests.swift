//
//  SimpleNetworkTests.swift
//  SimpleNetworkTests
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import XCTest
@testable import SimpleNetwork

class SimpleNetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
        let router = AuthRouter(call: .sendSms)
        let s = SimpleNetworkManager()
        
        let expect = expectation(description: "api call")
        s.callAPI(router: router.router) { response in
            print("response: \(response)")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)

    }
    
    func testUploadImage() {
        
        let router = AuthRouter(call: .upload)
        let s = SimpleNetworkManager()
        let expect = expectation(description: "upload image call")

        s.uploadImage(data: Data(),
                      router: router.router) { response in
                        expect.fulfill()

                        
                        print("response: \(response)")
        }
        wait(for: [expect], timeout: 30)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
