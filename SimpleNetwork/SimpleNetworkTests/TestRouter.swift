//
//  TestRouter.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation
@testable import SimpleNetwork

class AuthRouter {
    
    lazy var router: Router = {
        let r = Router()
        r.apiParams = self
        r.delegate = self
        return r
    }()
    
    enum APICalls {
        case sendSms
    }
    
    var call: APICalls!
    
    init(call: APICalls) {
        self.call = call
    }
    
}

extension AuthRouter: APIParams {
    
    public func url() -> String {
        switch  call! {
        case .sendSms:
            return "https://app-4996.on-aptible.com/api/auth/login/sms"
        }
    }
    
    public func HTTPMethod() -> HTTPMethods {
        
        return .post
    }
    
    public func parameters() -> Parameters? {
        switch  call! {
        case .sendSms:
            return ["phone": "+972544813444"]
        }
    }
    
    public func timeoutInterval() -> TimeInterval {
        return Router.defaultTimeoutInterval
    }
}

extension AuthRouter: RouterDelegate {
    
    public func addHeaders(toRequest request: inout URLRequest) {
        
//        APIManager.addHeaders(toRequest: &request, withHeaders: [.timeZone, .appVersion(version: Bundle.appVersion)])
        
    }
}
