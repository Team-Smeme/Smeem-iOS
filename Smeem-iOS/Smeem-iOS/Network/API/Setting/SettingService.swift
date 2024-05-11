//
//  SettingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import Foundation
import Moya

final class SettingService: SettingServiceProtocol {

    var provider: MoyaProvider<SettingEndPoint>!
    
    init(provider: MoyaProvider<SettingEndPoint> = MoyaProvider<SettingEndPoint>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func settingGetAPI(completion: @escaping (Result<SettingResponse, SmeemError>) -> ()) {
        self.provider.request(.settingInfo) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<SettingResponse>.self).data else {
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
    
    func editPushAPI(param: EditPushRequest, completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        self.provider.request(.editPush(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try response.map(GeneralResponse<NilType>?.self) else {
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
    
    func editPlanPatchAPI(param: PlanIdRequest,
                          completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        self.provider.request(.editPlan(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try response.map(GeneralResponse<NilType>?.self) else {
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
