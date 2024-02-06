//
//  OnboardingAPI.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/24.
//

import Foundation
import Moya

public class OnboardingAPI {
    
    static let shared = OnboardingAPI()
    private let onboardingProvider = MoyaProvider<OnboardingService>(plugins: [MoyaLoggingPlugin()])
    
    func planList(completion: @escaping (Result<[Goal], SmeemError>) -> ()) {
        onboardingProvider.request(.trainingGoal) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                do {
                    guard let data = try result.map(GeneralResponse<TrainingGoalResponse>.self).data?.goals else { return }
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
    
    func trainingWayGetAPI(param: String, completion: @escaping (Result<TrainingWayResponse, SmeemError>) -> ()) {
        onboardingProvider.request(.trainingWay(param: param)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                do {
                    guard let data = try result.map(GeneralResponse<TrainingWayResponse>.self).data else { return }
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
    
    func userPlanPathAPI(param: UserPlanRequest, accessToken: String, completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        onboardingProvider.request(.onboardingUserPlan(param: param, token: accessToken)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                do {
                    // TODO : response 형식에 따른 처리 고민 필요
                    let data = try result.map(GeneralResponse<NilType>.self)
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
    
    func serviceAcceptedPatch(param: ServiceAcceptRequest, accessToken: String, completion: @escaping (Result<ServiceAcceptResponse, SmeemError>) -> ()) {
        onboardingProvider.request(.serviceAccept(param: param, token: accessToken)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                do {
                    guard let data = try result.map(GeneralResponse<ServiceAcceptResponse>.self).data else { return }
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
    
    func ninknameCheckAPI(userName: String, accessToken: String, completion: @escaping (Result<NicknameCheckResponse, SmeemError>) -> Void) {
        onboardingProvider.request(.checkNickname(param: userName, token: accessToken)) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                do {
                    guard let data = try result.map(GeneralResponse<NicknameCheckResponse>.self).data else { return }
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
