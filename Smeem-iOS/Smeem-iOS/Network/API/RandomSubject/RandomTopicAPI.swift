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
    
    private var randomTopicData: RandomTopicResponse?
    
    func getRandomSubject(completion: @escaping
                          (RandomTopicResponse?) -> Void) {
        randomTopicProvider.request(.randomSubject) { response in
            switch response {
            case .success(let result):
                do {
                    self.randomTopicData = try result.map(RandomTopicResponse.self)
                    completion(self.randomTopicData)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
