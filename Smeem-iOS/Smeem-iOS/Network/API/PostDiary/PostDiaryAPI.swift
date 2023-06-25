//
//  PostDiaryAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

final class PostDiaryAPI {
    static let shared = PostDiaryAPI()
    private let postDiaryProvider = MoyaProvider<PostDiaryService>(plugins: [MoyaLoggingPlugin()])
    
    private var postDiaryData: PostDiaryResponse?
    
    func postDiary(param:PostDiaryRequest, completion: @escaping (PostDiaryResponse?) -> Void) {
        postDiaryProvider.request(.postDiary(param: param)) { response in
            switch response {
            case .success(let result):
                do {
                    self.postDiaryData = try
                    result.map(PostDiaryResponse.self)
                    completion(self.postDiaryData)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
