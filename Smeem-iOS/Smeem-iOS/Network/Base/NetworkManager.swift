//
//  NetworkManager.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/24.
//

import Foundation

final class NetworkManager {
    static func statusCodeErrorHandling(statusCode: Int) throws {
        switch statusCode {
        case 400..<500:
            throw SmeemError.clientError
        case 500...:
            throw SmeemError.serverError
        default:
            return
        }
    }
}
