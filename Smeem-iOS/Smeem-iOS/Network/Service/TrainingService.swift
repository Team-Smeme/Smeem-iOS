//
//  TrainingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/09.
//

import Foundation

protocol TrainingServiceProtocol {
    func getTrainingGoal() async throws -> BaseResponse<TrainingGoalsArrayResponse>?
    func getTrainingHow(query: String) async throws -> BaseResponse<TrainingHowResponse>?
    func pathUserTraingInfo(model: UserTrainingInfoRequest) async throws -> BaseResponse<NilType>?
}

struct TrainingService: TrainingServiceProtocol {

    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func getTrainingGoal() async throws -> BaseResponse<TrainingGoalsArrayResponse>? {
        let urlRequest = TrainingEndPoint.trainingGoal.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func getTrainingHow(query: String) async throws -> BaseResponse<TrainingHowResponse>? {
        let urlRequest = TrainingEndPoint.trainingHow(query: query).makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func pathUserTraingInfo(model: UserTrainingInfoRequest) async throws -> BaseResponse<NilType>? {
        let urlRequest = TrainingEndPoint.userTrainingInfo(model: model).makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
