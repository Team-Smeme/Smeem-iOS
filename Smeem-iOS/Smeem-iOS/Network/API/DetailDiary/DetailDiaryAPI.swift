//
//  DetailDiaryAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

final class DetailDiaryAPI {
    static let shared = DetailDiaryAPI()
    private let detailDiaryProvider = MoyaProvider<DetailDiaryService>(plugins:[MoyaLoggingPlugin()])
    
    func getDetailDiary(diaryID: Int,
                        completion: @escaping (Result<DetailDiaryResponse, SmeemError>) -> ()) {
        detailDiaryProvider.request(.detailDiary(diaryID: diaryID)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<DetailDiaryResponse>.self).data else {
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
    
    func deleteDiary(diaryID: Int,
                     completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        detailDiaryProvider.request(.deleteDiary(diaryID: diaryID)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<NilType>.self) else {
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
