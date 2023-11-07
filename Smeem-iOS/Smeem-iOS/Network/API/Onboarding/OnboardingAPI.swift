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
    
    func planList(completion: @escaping (GeneralResponse<TrainingGoalsArrayResponse>) -> Void) {
        onboardingProvider.request(.planList) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<TrainingGoalsArrayResponse>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func detailPlanList(param: String, completion: @escaping (GeneralResponse<TrainingHowResponse>) -> Void) {
        onboardingProvider.request(.detailPlanList(param: param)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<TrainingHowResponse>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func userPlanPathAPI(param: UserTrainingInfoRequest, accessToken: String, completion: @escaping (GeneralResponse<VoidType>) -> Void) {
        onboardingProvider.request(.onboardingUserPlan(param: param, token: accessToken)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<VoidType>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func serviceAcceptedPatch(param: ServiceAcceptRequest, accessToken: String, completion: @escaping (GeneralResponse<ServiceAcceptResponse>) -> Void) {
        onboardingProvider.request(.serviceAccept(param: param, token: accessToken)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<ServiceAcceptResponse>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func ninknameCheckAPI(userName: String, accessToken: String, completion: @escaping (GeneralResponse<NicknameValidResponse>) -> Void) {
        onboardingProvider.request(.checkNickname(param: userName, token: accessToken)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<NicknameValidResponse>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
