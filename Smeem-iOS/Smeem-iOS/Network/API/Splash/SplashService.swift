//
//  SplashService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/20/24.
//

import Foundation
import Moya

final class SplashService: SplashServiceProtocol {
    
    var provider: MoyaProvider<SplashEndPoint>!
    
    init(provider: MoyaProvider<SplashEndPoint> = MoyaProvider<SplashEndPoint>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func updateGetAPI(completion: @escaping (Result<UpdateResponse, SmeemError>) -> ()) {
        self.provider.request(.update) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<UpdateResponse>.self).data else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch let error {
                   guard let smeemError = error as? SmeemError else { return }
                   completion(.failure(smeemError))
               }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
}
