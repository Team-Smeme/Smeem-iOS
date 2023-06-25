//
//  RandomSubjectAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/21.
//

import Moya

final class RandomSubjectAPI {
    static let shared: RandomSubjectAPI = RandomSubjectAPI()
    private let randomSubjectProvider = MoyaProvider<RandomSubjectService>(plugins: [MoyaLoggingPlugin()])
    
    private var randomSubjectData: RandomSubjectResponse?
    
    func getRandomSubject(completion: @escaping
                          (RandomSubjectResponse?) -> Void) {
        randomSubjectProvider.request(.randomSubject) { response in
            switch response {
            case .success(let result):
                do {
                    self.randomSubjectData = try result.map(RandomSubjectResponse.self)
                    completion(self.randomSubjectData)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
