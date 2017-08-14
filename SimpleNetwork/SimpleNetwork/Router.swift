//
//  Router.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation
import Alamofire


public protocol APIParams: class {
    
    func url() -> String
    func HTTPMethod() -> HTTPMethods
    func parameters() -> Parameters?
    func timeoutInterval() -> TimeInterval
    
}

public protocol RouterDelegate: class {
    func addHeaders(toRequest request: inout URLRequest)
}

public enum RoutingError: Error {
    case error
}

public enum HTTPMethods: String {
    
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    
    //        case options = "OPTIONS"
    //        case head    = "HEAD"
    //        case patch   = "PATCH"
    //        case trace   = "TRACE"
    //        case connect = "CONNECT"
}

open class Router: URLRequestConvertible {
    
    public var apiParams: APIParams?
    public var delegate: RouterDelegate?
    
    
    /// 10 seconds default timeout interval
    public static let defaultTimeoutInterval: TimeInterval = 1000*10
    
    public init() {}
    
    public func asURLRequest() throws -> URLRequest {
        
        guard let apiParams = apiParams,
            let url = URL(string: apiParams.url().urlEncoded) else {
                throw RoutingError.error
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiParams.HTTPMethod().rawValue
        
        if let delegate = delegate {
            delegate.addHeaders(toRequest: &request)
        }
        
        request.timeoutInterval = apiParams.timeoutInterval()
        let r = try URLEncoding.default.encode(request, with: apiParams.parameters())
        return r
    }
    
}
