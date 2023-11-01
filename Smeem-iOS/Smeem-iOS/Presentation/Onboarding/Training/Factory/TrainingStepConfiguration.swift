//
//  TrainingStepConfiguration.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/11/01.
//

import Foundation

struct TrainingStepConfiguration {
    let stepText: String
    let titleLearningText: String
    let detailLearningText: String
    let nextButtonTitleText: String
}

enum TrainingStep {
    case goals
    case way
    case alarm
}
