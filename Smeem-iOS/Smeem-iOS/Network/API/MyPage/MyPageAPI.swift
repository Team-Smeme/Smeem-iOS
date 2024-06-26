//
//  MyPageAPI.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation
import Moya

final class MyPageAPI {
    static let shared = MyPageAPI()
    private let myPageProvider = MoyaProvider<MyPageService>(plugins: [MoyaLoggingPlugin()])
    
    func myPageInfo(completion: @escaping (Result<MyPageResponse, SmeemError>) -> ()) {
        myPageProvider.request(.myPageInfo) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<MyPageResponse>.self).data else {
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
    
    func changeMyNickName(request: EditNicknameRequest,
                          completion: @escaping (Result<ServiceAcceptResponse, SmeemError>) -> ()) {
        myPageProvider.request(.editNickname(param: request)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try response.map(GeneralResponse<ServiceAcceptResponse>.self).data else {
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
    
    func checkNinknameAPI(param: String,
                          completion: @escaping (Result<NicknameCheckResponse, SmeemError>) -> ()) {
        myPageProvider.request(.checkNinkname(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<NicknameCheckResponse>.self).data else {
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
    
    func changeGoal(param: EditGoalRequest,
                    completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        myPageProvider.request(.editGoal(param: param)) { result in
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
    
    func badgeListAPI(completion: @escaping (Result<[MyPageBadgeArray], SmeemError>) -> ()) {
        myPageProvider.request(.badgeList) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<MyPageBadgeListReponse>.self).data?.badgeTypes else {
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
    
    func userPlanPathAPI(param: TrainingPlanRequest,
                         completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        myPageProvider.request(.myPageUserPlan(param: param)) { result in
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
                completion(.failure(.serverError))
            }
        }
    }
    
    func editAlarmTimeAPI(param: EditAlarmTime,
                          completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        myPageProvider.request(.editAlarmTime(param: param)) { result in
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
    
    func editPushAPI(param: EditPushRequest,
                     completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        myPageProvider.request(.editPush(param: param)) { result in
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
