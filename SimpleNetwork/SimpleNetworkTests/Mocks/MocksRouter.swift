//
//  MocksRouter.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 16/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation
@testable import SimpleNetwork

class MocksRouter {
    
    lazy var router: Router = {
        let r = Router()
        r.apiParams = self
        r.delegate = self
        return r
    }()
    
    enum APICalls {
        case get
    }
    
    var call: APICalls!
    
    init(call: APICalls) {
        self.call = call
    }
    
}

extension MocksRouter: APIParams {
    
    public func url() -> String {
        switch  call! {
        case .get:
            return "https://http://httpbin.org/get"
        }
    }
    
    public func HTTPMethod() -> HTTPMethod {
        
        return .get
    }
    
    public func parameters() -> Parameters? {
        switch  call! {
        case .get:
            return nil
        }
    }
    
    public func timeoutInterval() -> TimeInterval {
        return Router.defaultTimeoutInterval
    }
}

extension MocksRouter: RouterDelegate {
    
    public func addHeaders(toRequest request: inout URLRequest) {
        let headers: [HttpHeader] = [
            .timeZone,
            .appVersion(version: "1.0.0"),
            .authorization(token: "1234567890")
        ]
        
        request.add(headers: headers)
    }
}
