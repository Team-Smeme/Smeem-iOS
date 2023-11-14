//
//  NetworkError.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/11/14.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case systemError
    case loadDataError
    case urlEncodingError
    case jsonDecodingError
    case unAuthorizedError
    case unknownError(message: String)
    case jsonEncodingError
    case typeCastingError
}
