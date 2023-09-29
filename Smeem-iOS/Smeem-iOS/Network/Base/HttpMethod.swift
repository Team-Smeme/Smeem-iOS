//
//  HttpMethod.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/07.
//

import Foundation

enum HttpMethod: String {
    case get
    case post
    case patch
    case delete
    case put
    
    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
}
