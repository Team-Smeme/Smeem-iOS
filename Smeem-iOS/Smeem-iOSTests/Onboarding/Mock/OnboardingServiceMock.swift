//
//  OnboardingServiceMock.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 3/1/24.
//

import Foundation

@testable import Smeem_iOS

final class OnboardingServiceMock: OnboardingServiceProtocol {
    
    func trainingGoalGetAPI(completion: @escaping (Result<[Smeem_iOS.Goal], Smeem_iOS.SmeemError>) -> ()) {
        completion(.success([Goal(goalType: "test", name: "안녕")]))
    }
    
    func trainingWayGetAPI(param: String, completion: @escaping (Result<Smeem_iOS.TrainingWayResponse, Smeem_iOS.SmeemError>) -> ()) {
        completion(.success(TrainingWayResponse(name: "test",
                                                way: "test",
                                                detail: "test")))
    }
    
    func userPlanPathAPI(param: Smeem_iOS.TrainingPlanRequest, accessToken: String, completion: @escaping (Result<Smeem_iOS.GeneralResponse<Smeem_iOS.NilType>, Smeem_iOS.SmeemError>) -> ()) {
            completion(.success(GeneralResponse(success: true, message: "test", data: nil)))
    }
    
    func serviceAcceptedPatch(param: Smeem_iOS.ServiceAcceptRequest, accessToken: String, completion: @escaping (Result<Smeem_iOS.ServiceAcceptResponse, Smeem_iOS.SmeemError>) -> ()) {
            completion(.success(ServiceAcceptResponse(badges: [PopupBadge(name: "test",
                                                                      imageUrl: "imageUrl",
                                                                      type: "test")])))
    }
    
    func ninknameCheckAPI(userName: String, accessToken: String, completion: @escaping (Result<Smeem_iOS.NicknameCheckResponse, Smeem_iOS.SmeemError>) -> Void) {
            completion(.success(NicknameCheckResponse(isExist: true)))
    }
}
