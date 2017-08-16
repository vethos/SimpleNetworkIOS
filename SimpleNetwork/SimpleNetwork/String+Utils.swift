//
//  String+Utils.swift
//  SimpleNetwork
//
//  Created by Ilan Ben Tal on 14/08/2017.
//  Copyright © 2017 Valera Health. All rights reserved.
//

import Foundation

extension String {
    
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
