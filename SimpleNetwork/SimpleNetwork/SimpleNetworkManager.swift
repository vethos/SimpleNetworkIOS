//
//  SimpleNetworkManager.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation
import Alamofire

class SimpleNetworkManager: SimpleNetworkDelegate {
    
    public weak var errorDelegate: SimpleNetworkErrorDelegate?
    
    /// call a netwok api call
    ///
    /// - Parameters:
    ///   - router: api call router
    ///   - callback: network response
    func callAPI(router: Router, callback: responseCallback?) {
        Alamofire
            .request(router)
            .validate()
            .responseJSON { [weak self] response in
                
                guard let me = self else { return }
            
                switch response.result {
                case .success(let json):
                    
                    guard let callback = callback else { return }
                    callback(.success(Response(response: json)))
                    
                case .failure:
                    
                    me.handleResponseError(response: response, callback: callback)
                    
                }
        }
    }
    
    
    /// Upload an image
    ///
    /// - Parameters:
    ///   - data: image Data
    ///   - router: api call router
    ///   - callback: network response
    func uploadImage(data: Data, router: Router, callback: responseCallback?) {
        Alamofire
            .upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(data, withName: "file", fileName: "filename", mimeType: "image/png")
        }, with: router) { [weak self] encodingResult in
            
            guard let me = self else { return }

            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseJSON(completionHandler: { response in
                    
                    switch response.result {
                    case .success(let json):
                        
                        guard let callback = callback else { return }
                        callback(.success(Response(response: json)))

                    case .failure(_):
                        
                        me.handleResponseError(response: response, callback: callback)
                        
                    }
                })
                
            case .failure(let error):
                me.handleRequestError(error: error, callback: callback)
            }
        }
    }
    
}

extension SimpleNetworkManager {
    
    fileprivate func handleRequestError(error: Error, callback: responseCallback?) {
        guard let callback = callback else { return }
        
        let json: [String: Any]
        switch error {
        case RoutingError.missingRouter:
            json = [
                "statusCode": 0,
                "message": "routingError"
            ]
        default:
            json = [
                "statusCode": 0,
                "message": "unknown error"
            ]
        }
        
        let response = ResponseError(statusCode: 0,
                                     response: json)
        
        
        if let errorDelegate = errorDelegate {
            errorDelegate.handle(error: response)
        }
        callback(.failure(response))
    }
    
    fileprivate func handleResponseError(response: DataResponse<Any>, callback: responseCallback?) {
        let statusCode = extractStatusCode(from: response.response)
        let json = errorToJson(data: response.data)
        
        guard let callback = callback else { return }
        
        let response = ResponseError(statusCode: statusCode,
                                     response: json)
        
        if let errorDelegate = errorDelegate {
            errorDelegate.handle(error: response)
        }
        callback(.failure(response))
    }
    
    
    /// Turns response error Data into JSONObject
    ///
    /// - Parameter data: response Data
    /// - Returns: error data as JSONObject
    fileprivate func errorToJson(data: Data?) -> JSONObject? {
        
        guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONObject
            else { return nil }
        
        return json
    }
    
    
    /// extract network response status code
    ///
    /// - Parameter response: network response
    /// - Returns: response status code default is 0
    fileprivate func extractStatusCode(from response: HTTPURLResponse?) -> Int {
        
        guard let statusCode = response?.statusCode else { return 0 }
        return statusCode
    }
}




