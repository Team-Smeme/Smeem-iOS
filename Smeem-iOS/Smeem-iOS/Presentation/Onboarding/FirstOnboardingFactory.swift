//
//  FirstOnboardingFactory.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/06.
//

import UIKit

final class FirstOnboardingFactory {
    // 리턴값으로 FirstOnboardingCollectionViewCell를 반환하려고 했는데 그러면 머 각종 초기화값 넣어 줘야 함
    func createPlanGoalCell() -> FirstOnboardingConfiguration {
        let builder = FirstOnboardingBuilder()
        let config = builder
            .setStepText(stepText: "1")
            .setTitleLearningText(titleLearningText: "트레이닝 목표 설정")
            .setDetailLearningText(detailLearningText: "마이페이지에서 언제든지 수정할 수 있어요!")
            .setNextButtonText(nextButtonText: "다음")
        
        return config.builder()
    }
    
    func createHowTrainingCell() -> FirstOnboardingConfiguration {
        let builder = FirstOnboardingBuilder()
        let config = builder
            .setStepText(stepText: "2")
            .setTitleLearningText(titleLearningText: "추천 트레이닝 방법")
            .setDetailLearningText(detailLearningText: "스밈과 함께한다면 분명 목표를 이룰 거예요!")
            .setNextButtonText(nextButtonText: "다음")
        
        return config.builder()
    }
    
    func createTrainingAlarmCell() -> FirstOnboardingConfiguration {
        let builder = FirstOnboardingBuilder()
        let config = builder
            .setStepText(stepText: "3")
            .setTitleLearningText(titleLearningText: "트레이닝 시간 설정")
            .setDetailLearningText(detailLearningText: "당신의 목표를 이룰 수 있도록 알림을 드릴게요!")
            .setNextButtonText(nextButtonText: "완료")
        
        return config.builder()
    }
}
