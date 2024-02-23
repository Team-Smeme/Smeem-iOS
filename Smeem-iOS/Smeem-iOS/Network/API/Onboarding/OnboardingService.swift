//
//  OnboardingAPI.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/24.
//

import Foundation
import Moya

public class OnboardingService {
    
    static let shared = OnboardingService()
    
    private var provider: MoyaProvider<OnboardingEndPoint>!
    
    init(provider: MoyaProvider<OnboardingEndPoint> = MoyaProvider<OnboardingEndPoint>()) {
        self.provider = provider
    }
    
    func trainingGoalGetAPI(completion: @escaping (Result<[Goal], SmeemError>) -> ()) {
        provider.request(.trainingGoal) { response in
            switch response {
            case .success(let result):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: result.statusCode)
                    guard let data = try? result.map(GeneralResponse<TrainingGoalResponse>.self).data?.goals else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                    
                } catch let error {
                    guard let smeemError = error as? SmeemError else { return }
                    completion(.failure(smeemError))
                }
                
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
    
    func trainingWayGetAPI(param: String, completion: @escaping (Result<TrainingWayResponse, SmeemError>) -> ()) {
        provider.request(.trainingWay(param: param)) { response in
            switch response {
            case .success(let result):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: result.statusCode)
                    guard let data = try? result.map(GeneralResponse<TrainingWayResponse>.self).data else {
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
    
    func userPlanPathAPI(param: TrainingPlanRequest, accessToken: String, completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        provider.request(.trainingUserPlan(param: param, token: accessToken)) { response in
            switch response {
            case .success(let result):
                do {
                    // TODO : response 형식에 따른 처리 고민 필요
                    try NetworkManager.statusCodeErrorHandling(statusCode: result.statusCode)
                    guard let data = try? result.map(GeneralResponse<NilType>.self) else {
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
    
    func serviceAcceptedPatch(param: ServiceAcceptRequest, accessToken: String, completion: @escaping (Result<ServiceAcceptResponse, SmeemError>) -> ()) {
        provider.request(.serviceAccept(param: param, token: accessToken)) { response in
            switch response {
            case .success(let result):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: result.statusCode)
                    guard let data = try? result.map(GeneralResponse<ServiceAcceptResponse>.self).data else {
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
    
    func ninknameCheckAPI(userName: String, accessToken: String, completion: @escaping (Result<NicknameCheckResponse, SmeemError>) -> Void) {
        provider.request(.checkNickname(param: userName, token: accessToken)) { response in
            switch response {
            case .success(let result):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: result.statusCode)
                    guard let data = try? result.map(GeneralResponse<NicknameCheckResponse>.self).data else {
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
