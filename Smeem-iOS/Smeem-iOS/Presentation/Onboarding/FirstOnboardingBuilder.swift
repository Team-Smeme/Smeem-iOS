//
//  FirstOnboardingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/04.
//

import Foundation

struct FirstOnboardingConfiguration {
    var stepText: String
    var titleLearningText: String
    var detailLearningText: String
    var nextButtonTitleText: String
}

final class FirstOnboardingBuilder {
    
    private var stepText = ""
    private var titleLearningText = ""
    private var detailLearningText = ""
    private var nextButtonTitleText = ""
    
    func setStepText(stepText: String) -> Self {
        self.stepText = stepText
        return self
    }

    func setTitleLearningText(titleLearningText: String) -> Self {
        self.titleLearningText = titleLearningText
        return self
    }

    func setDetailLearningText(detailLearningText: String) -> Self {
        self.detailLearningText = detailLearningText
        return self
    }

    func setNextButtonText(nextButtonText: String) -> Self {
        self.nextButtonTitleText = nextButtonText
        return self
    }
    
    func builder() -> FirstOnboardingConfiguration {
        return FirstOnboardingConfiguration(stepText: stepText,
                                            titleLearningText: titleLearningText,
                                            detailLearningText: detailLearningText,
                                            nextButtonTitleText: nextButtonTitleText)
    }
}
