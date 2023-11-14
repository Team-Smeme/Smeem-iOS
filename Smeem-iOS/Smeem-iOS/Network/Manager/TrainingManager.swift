//
//  TrainingManager.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/09.
//

import Foundation

protocol TrainingManagerProtocol {
    func getTrainingGoal() async throws -> [TrainingGoals]
    func getTrainingHow(query: String) async throws -> TrainingWayClientModel
    func pathUserTraingInfo(model: UserTrainingInfoRequest) async throws
}

struct TrainingManager: TrainingManagerProtocol {
    
    private let trainingService: TrainingService
    
    init(trainingService: TrainingService) {
        self.trainingService = trainingService
    }
    
    func getTrainingGoal() async throws -> [TrainingGoals] {
        guard let response = try await trainingService.getTrainingGoal()?.data?.goals else { return [TrainingGoals.empty] }
        return response
    }
    
    func getTrainingHow(query: String) async throws -> TrainingWayClientModel {
        guard let response = try await trainingService.getTrainingHow(query: query)?.data else { return TrainingWayClientModel.empty }
        
        let trainingTitle = response.name
        let trainingWayList = response.way.components(separatedBy: " 이상 ")
        let trainingFirstWay = trainingWayList[0] + " 이상"
        let trainingSecondeWay = trainingWayList[1] + " 이상"
        let detailTrainingWay = response.detail.components(separatedBy: "\n")
        
        return TrainingWayClientModel(trainingTitle: trainingTitle,
                                      trainingWays: [trainingFirstWay, trainingSecondeWay], detailTrainingWay: detailTrainingWay)
    }
    
    func pathUserTraingInfo(model: UserTrainingInfoRequest) async throws {
        guard let _ = try await trainingService.pathUserTraingInfo(model: model)?.data else { return }
    }
}
