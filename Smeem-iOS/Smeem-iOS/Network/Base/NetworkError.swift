//
//  NetworkError.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/07.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case urlEncodingError
    case jsonDecodingError
    case unAuthorizedError
    case clientError(message: String)
    case serverError
    case jsonEncodingError
    
    var description: String {
        switch self {
        case .urlEncodingError:
            return "URL Encoding Error"
        case .jsonDecodingError:
            return "Json Decoding Error"
        case .unAuthorizedError:
            return "Token Error"
        case .clientError(let message):
            return "Clinet Error \(message)"
        case .serverError:
            return "Server Error"
        case .jsonEncodingError:
            return "Json Encoding Error"
        }
    }
}

// case fetchImageError
// case badCastingError
