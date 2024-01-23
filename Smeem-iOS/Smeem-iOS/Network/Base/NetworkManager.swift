//
//  NetworkManager.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/24.
//

import Foundation

final class NetworkManager {
    static func statusCodeErrorHandling(statusCode: Int) -> SmeemErrorMessage {
        switch statusCode {
        case 400..<500:
            return .clientError
        case 500...:
            return .serverError
        default: break
        }
        return .userError
    }
}
