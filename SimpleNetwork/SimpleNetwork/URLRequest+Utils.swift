//
//  URLRequest+Utils.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 16/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation
import UIKit

extension URLRequest {
    
    /// Add http headers to request
    ///
    /// - Parameter headers: HttpHeaders to add
    public mutating func add(headers: [HttpHeader]) {
        for header in headers {
            setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
