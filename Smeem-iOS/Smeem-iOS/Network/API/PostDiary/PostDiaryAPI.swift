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
    
    private var postDiaryData: GeneralResponse<PostDiaryResponse>?
    
    func postDiary(param:PostDiaryRequest, completion: @escaping (GeneralResponse<PostDiaryResponse>?) -> Void) {
        postDiaryProvider.request(.postDiary(param: param)) { response in
            switch response {
            case .success(let result):
                do {
                    self.postDiaryData = try
                    result.map(GeneralResponse<PostDiaryResponse>.self)
                    completion(self.postDiaryData)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func patchDiary(param: PatchDiaryRequest, diaryID: Int, completion: @escaping (GeneralResponse<NilType>?) -> Void) {
        postDiaryProvider.request(.patchDiary(param: param, query: diaryID)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<NilType>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
