//
//  NetworkResponse.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation

public typealias JSONObject = [String: Any]
public typealias JSONArray = [JSONObject]
public typealias Parameters = JSONObject
public typealias responseCallback = (NetworkResponse) -> ()

//used to store response error data
public struct ResponseError {
    public let statusCode: Int
    public let response: JSONObject?
}

//used to store response data
public struct Response {
    public let response: Any?
}

/**
 Used to represent whether a request was successful or encountered an error.
 
 - Success: The request and all post processing operations were successful.
 - Failure: The request encountered an error resulting in a failure.
 */
public enum NetworkResponse {
    case success(Response)
    case failure(ResponseError)
}

//extend JSONObject
extension Dictionary where Key == String, Value: Any  {
    
    var stringify: String {
        
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let pretty = String(data: data, encoding: .utf8)
            else { return "" }
        
        return pretty
    }
}

//func prettyPrint(with json: JSONObject) -> String{
//    let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//    return string as! String
//}
