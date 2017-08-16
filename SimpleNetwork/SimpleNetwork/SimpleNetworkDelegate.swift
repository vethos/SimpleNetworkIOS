//
//  SimpleNetworkDelegate.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation


/// Delegate for the wraper api manager
public protocol SimpleNetworkDelegate: class {
    func callAPI(router: Router, callback: responseCallback?)
    func uploadImage(data: Data, router: Router, callback: responseCallback?)
}

/// Delegate for handling a error globaly by a api manager
public protocol SimpleNetworkErrorDelegate: class {
    func handle(error: ResponseError)
}
