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
    
    func postDiary(param:PostDiaryRequest, completion: @escaping (Result<PostDiaryResponse, SmeemError>) -> Void) {
        postDiaryProvider.request(.postDiary(param: param)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                do {
                    guard let data = try
                            result.map(GeneralResponse<PostDiaryResponse>.self).data else { return }
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
