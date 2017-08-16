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
    func HTTPMethod() -> HTTPMethod
    func parameters() -> Parameters?
    func timeoutInterval() -> TimeInterval
    
}

public protocol RouterDelegate: class {
    func addHeaders(toRequest request: inout URLRequest)
}

public enum RoutingError: Error {
    case missingRouter
}

public enum HttpHeader {
    
    case authorization(token: String)
    case appVersion(version: String)
    case timeZone
    case version(number: String)
    case custom(key: String, value: String)
    
    var key: String {
        switch self {
        case .authorization:
            return "Authorization"
        case .appVersion:
            return "App-Version"
        case .timeZone:
            return "Timezone"
        case .version:
            return "version"
        case .custom(let key, _):
            return key
        }
    }
    
    var value: String {
        switch self {
        case .authorization(let token):
            return "Bearer \(token)"
        case .appVersion(let version):
            return version
        case .timeZone:
            return TimeZone.current.identifier
        case .version(let number):
            return number
        case .custom(_, let value):
            return value
        }
    }
}

public enum HTTPMethod: String {
    
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
                throw RoutingError.missingRouter
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
