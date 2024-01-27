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
                        completion: @escaping (Result<DetailDirayData, SmeemError>) -> ()) {
        detailDiaryProvider.request(.detailDiary(diaryID: diaryID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    guard let data = try response.map(GeneralResponse<DetailDiaryResponse>.self).data?.data else { return }
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
    
    func deleteDiary(diaryID: Int,
                     completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        detailDiaryProvider.request(.deleteDiary(diaryID: diaryID)) { result in
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
