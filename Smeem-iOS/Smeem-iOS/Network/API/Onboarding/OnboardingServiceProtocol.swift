//
//  OnboardingServiceProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/2/24.
//

import Foundation

protocol OnboardingServiceProtocol {
    func trainingGoalGetAPI(completion: @escaping (Result<[Goal], SmeemError>) -> ())
    func trainingPlanGETAPI(completion: @escaping (Result<[Plans], SmeemError>) -> ())
    func trainingWayGetAPI(param: String, completion: @escaping (Result<TrainingWayResponse, SmeemError>) -> ())
    func userPlanPathAPI(param: TrainingPlanRequest, accessToken: String, completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ())
    func serviceAcceptedPatch(param: ServiceAcceptRequest, accessToken: String, completion: @escaping (Result<ServiceAcceptResponse, SmeemError>) -> ())
    func ninknameCheckAPI(userName: String, accessToken: String, completion: @escaping (Result<NicknameCheckResponse, SmeemError>) -> Void)
}
