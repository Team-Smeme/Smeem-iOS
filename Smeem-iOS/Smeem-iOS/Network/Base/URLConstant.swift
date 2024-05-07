//
//  URLConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/02.
//

import Foundation

enum URLConstant {
    
    // MARK: Splash
    
    static let updateURL = "versions/client/app"
    
    // MARK: Auth
    
    static let loginURL = "/auth"
    static let logoutURL = "/auth/sign-out"
    static let reLoginURL = "/auth/token"
    
    // MARK: Onboarding
    
    static let trainingGoalsURL = "/goals"
    static let trainingPlanURL = "/plans"
    static let userURL = "/members"
    static let userTrainingInfo = "/members/plan"
    static let checkNickname = "/members/nickname/check"
    
    // MARK: - MyPage
    
    static let badgesListURL = "/members/badges"
    static let myPageURL = "/members/me"
    
    // MARK: - MySummary
    
    static let mySummaryURL = "/members/performance/summary"
    static let myPlanURL = "/members/plan"
    static let myBadgeURL = "/members/badges"
    
    // MARK: - Diary
    
    static let diaryURL = "/diaries"
    
    // MARK: - Correction
    
    static let correctionPostURL = "/corrections/diary"
    static let correctionURL = "/corrections"
    
    // MARK: - RandomSubject
    
    static let randomSubjectURL = "/topics/random"
    
    // MARK: - Push
    
    static let pushURL = "/members/push"
    
    // MARK: - DeepL
    
    static let deepLBaseURL = "https://api-free.deepl.com"
    static let deepLPathURL = "/v2/translate"
    
    // MARK: - Push
    
    static let pushTestURL = "/test/alarm"
}
