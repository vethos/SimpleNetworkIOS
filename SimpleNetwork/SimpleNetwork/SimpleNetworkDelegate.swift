//
//  SimpleNetworkDelegate.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation

protocol SimpleNetworkDelegate: class {
    func callAPI(router: Router, callback: responseCallback?)
    func uploadImage(data: Data, router: Router, callback: responseCallback?)
}
