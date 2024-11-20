//
//  MoyaProvier+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import Foundation
import Moya

class ServiceNetwork {
    
    static let shared = ServiceNetwork()
    
    private init() {}
    
    func request<T: Decodable, Target: TargetType>(_ target: Target) async throws -> T {
        let provider = MoyaProvider<Target>(plugins: [MoyaLoggingPlugin()])
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                        if let data = try response.map(GeneralResponse<T>.self).data {
                            continuation.resume(returning: data)
                        } else {
                            continuation.resume(throwing: SmeemError.clientError)
                        }
                    } catch {
                        continuation.resume(throwing: SmeemError.clientError)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension MoyaProvider {
    func request<T: Decodable>(_ target: Target) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                        if let data = try response.map(GeneralResponse<T>.self).data {
                            continuation.resume(returning: data)
                        } else {
                            continuation.resume(throwing: SmeemError.clientError)
                        }
                    } catch {
                        continuation.resume(throwing: SmeemError.clientError)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
