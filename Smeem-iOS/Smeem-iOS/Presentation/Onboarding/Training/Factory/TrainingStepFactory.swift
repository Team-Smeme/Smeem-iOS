//
//  FirstOnboardingFactory.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/06.
//

import UIKit

protocol TrainingStepProtocol {
    func makeStepView(type: TrainingStep) -> TrainingStepConfiguration
}

struct TrainingStepFactory: TrainingStepProtocol {
    func makeStepView(type: TrainingStep) -> TrainingStepConfiguration {
        switch type {
        case .goals:
            return makeTrainingPlansStepView()
        case .way:
            return makeTrainingWayStepView()
        case .alarm:
            return makeTrainingAlarmStepView()
        }
    }
}

extension TrainingStepFactory {
    private func makeTrainingPlansStepView() -> TrainingStepConfiguration {
        TrainingStepConfiguration(stepText: "1",
                                     titleLearningText: "트레이닝 목표 설정",
                                     detailLearningText: "마이페이지에서 언제든지 수정할 수 있어요",
                                     nextButtonTitleText: "다음")
    }
    
    private func makeTrainingWayStepView() -> TrainingStepConfiguration {
        TrainingStepConfiguration(stepText: "2",
                                     titleLearningText: "추천 트레이닝 방법",
                                     detailLearningText: "스밈과 함께한다면 분명 목표를 이룰 거예요",
                                     nextButtonTitleText: "다음")
    }
    
    private func makeTrainingAlarmStepView() -> TrainingStepConfiguration {
        TrainingStepConfiguration(stepText: "3",
                                     titleLearningText: "트레이닝 시간 설정",
                                     detailLearningText: "당신의 목표를 이룰 수 있도록 알림을 드릴게요!",
                                     nextButtonTitleText: "완료")
    }
}
