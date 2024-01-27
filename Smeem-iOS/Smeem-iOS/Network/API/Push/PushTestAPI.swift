//
//  PushTestAPI.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/05.
//

import Moya

final class PushTestAPI {
    static let shared = PushTestAPI()
    private let pushTestProvider = MoyaProvider<PushTestService>(plugins: [MoyaLoggingPlugin()])
    
    func getPustTest(completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        pushTestProvider.request(.pushTest) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    guard let data = try response.map(GeneralResponse<NilType>?.self) else { return }
                    completion(.success(data))
                } catch {
                    let error = NetworkManager.statusCodeErrorHandling(statusCode: statusCode)
                    completion(.failure(error))
                }
                
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
}
