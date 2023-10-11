//
//  TrainingWayClientModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/10.
//

import Foundation

struct TrainingWayClientModel {
    let trainingTitle: String
    let trainingWays: [String]
    let detailTrainingWay: [String]
}

extension TrainingWayClientModel {
    static let empty = TrainingWayClientModel(trainingTitle: "",
                                              trainingWays: [""],
                                              detailTrainingWay: [""])
}
