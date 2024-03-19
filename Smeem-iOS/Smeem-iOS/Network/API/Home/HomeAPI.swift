//
//  HomeAPI.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/26.
//

import Foundation

import Moya

final class HomeAPI {
    static let shared = HomeAPI()
    private let homeProvider = MoyaProvider<HomeService>(plugins: [MoyaLoggingPlugin()])
    
    func homeDiaryList(startDate: String,
                       endDate: String,
                       completion: @escaping (Result<HomeDiaryResponse, SmeemError>) -> ()) {
        homeProvider.request(.HomeDiary(startDate: startDate, endDate: endDate)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<HomeDiaryResponse>.self).data else {
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
