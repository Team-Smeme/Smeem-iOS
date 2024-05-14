//
//  DeepLAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/01/15.
//

import Foundation

import Moya

final class DeepLAPI {
    static let shared = DeepLAPI()
    
    private let deepLProvider = MoyaProvider<DeepLService>(plugins: [MoyaLoggingPlugin()])
    
    private var deepLResponse: DeepLResponse?
    
    func postTargetText(text: String, completion: @escaping (Result<DeepLResponse?, SmeemError>) -> Void) {
        let deepLService = DeepLService(text: text, authToken: ConfigConstant.deepLToken)
        
        deepLProvider.request(deepLService) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let deepLResponse = try decoder.decode(DeepLResponse.self, from: response.data)
                    completion(.success(deepLResponse))
                } catch {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(.userError))
            }
        }
    }
}
