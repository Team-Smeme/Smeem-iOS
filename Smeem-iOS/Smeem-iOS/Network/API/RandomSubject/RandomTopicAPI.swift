//
//  RandomTopicAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/21.
//

import Moya

final class RandomTopicAPI {
    static let shared = RandomTopicAPI()
    
    private let randomTopicProvider = MoyaProvider<RandomTopicService>(plugins: [MoyaLoggingPlugin()])
    
    func getRandomSubject(completion: @escaping (Result<RandomTopicResponse, SmeemError>) -> Void) {
        randomTopicProvider.request(.randomSubject) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                do {
                    guard let data = try result.map(GeneralResponse<RandomTopicResponse>.self).data else { return }
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
