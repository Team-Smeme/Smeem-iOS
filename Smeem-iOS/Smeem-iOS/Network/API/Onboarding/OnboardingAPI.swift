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
//    private var nicknameResponse: NicknameResponse?
    
    func planList(completion: @escaping (GeneralResponse<PlanListResponse>) -> Void) {
        onboardingProvider.request(.planList) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<PlanListResponse>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func detailPlanList(param: String, completion: @escaping (GeneralResponse<DetailPlanListResponse>) -> Void) {
        onboardingProvider.request(.detailPlanList(param: param)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<DetailPlanListResponse>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func userPlanPathAPI(param: UserPlanRequest, accessToken: String, completion: @escaping (GeneralResponse<VoidType>) -> Void) {
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
    
    func ninknameCheckAPI(userName: String, accessToken: String, completion: @escaping (GeneralResponse<NicknameCheckResponse>) -> Void) {
        onboardingProvider.request(.checkNickname(param: userName, token: accessToken)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<NicknameCheckResponse>.self) else {
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
