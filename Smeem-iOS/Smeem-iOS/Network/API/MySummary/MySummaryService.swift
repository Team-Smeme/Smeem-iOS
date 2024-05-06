//
//  MySummaryService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/28/24.
//

import Foundation
import Moya

final class MySummaryService: MySummaryServiceProtocol {
    
    var provider: MoyaProvider<MySummaryEndPoint>!
//    
    
    init(provider: MoyaProvider<MySummaryEndPoint> = MoyaProvider<MySummaryEndPoint>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func mySummaryGetAPI(completion: @escaping (Result<MySummaryResponse, SmeemError>) -> ()) {
        self.provider.request(.mySummary) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<MySummaryResponse>.self).data else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch let error {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
    
    func myPlanGetAPI(completion: @escaping (Result<GeneralResponse<MyPlanResponse>, SmeemError>) -> ()) {
        self.provider.request(.myPlan) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<MyPlanResponse>.self) else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch let error {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
    
    func myBadgeGetAPI(completion: @escaping (Result<[MySummaryBadgeResponse], SmeemError>) -> ()) {
        self.provider.request(.myBadge) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<MySummaryBadgeArrayResponse>.self).data?.badges else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch let error {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
}
