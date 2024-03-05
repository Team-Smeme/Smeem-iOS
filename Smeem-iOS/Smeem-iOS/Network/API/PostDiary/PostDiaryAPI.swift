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
        postDiaryProvider.request(.postDiary(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try
                            response.map(GeneralResponse<PostDiaryResponse>.self).data else {
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
    
    func patchDiary(param: PatchDiaryRequest, diaryID: Int, completion: @escaping (Result<NilType, SmeemError>) -> Void) {
        postDiaryProvider.request(.patchDiary(param: param, query: diaryID)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<NilType>.self).data else {
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
