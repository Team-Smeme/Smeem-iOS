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
        randomTopicProvider.request(.randomSubject) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<RandomTopicResponse>.self).data else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
}
