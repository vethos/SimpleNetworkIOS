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
                    
                    let statusCode = me.extractStatusCode(from: response.response)
                    let json = me.errorToJson(data: response.data)
                    
                    guard let callback = callback else { return }
                    
                    let response = ResponseError(statusCode: statusCode,
                                                 response: json)
                    callback(.failure(response))
                    
                }
        }
    }
    
    func uploadImage(data: Data, router: Router, callback: responseCallback?) {
        
    }
    
}

extension SimpleNetworkManager {
    
    fileprivate func errorToJson(data: Data?) -> JSONObject? {
        
        guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONObject
            else { return nil }
        
        return json
    }
    
    fileprivate func extractStatusCode(from response: HTTPURLResponse?) -> Int {
        
        guard let statusCode = response?.statusCode else { return 0 }
        return statusCode
    }
}




