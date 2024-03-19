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
    
    func postTargetText(text: String, completion: @escaping ((DeepLResponse)?) -> Void) {
        let deepLService = DeepLService(text: text, authToken: ConfigConstant.deepLToken)
        
        deepLProvider.request(deepLService) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let deepLResponse = try decoder.decode(DeepLResponse.self, from: response.data)
                    completion(deepLResponse)
                } catch {
                    print("Failed to decode DeepLResponse: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
