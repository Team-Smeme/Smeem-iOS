//
//  URLConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/02.
//

import Foundation

enum URLConstant {
    
    // MARK: Auth
    
    static let loginURL = "/auth"
    static let logoutURL = "/auth/sign-out"
    static let tokenURL = "/auth/token"
    
    // MARK: Onboarding
    
    static let userURL = "/members"
    static let userPlanURL = "/members/plan"
    
    // MARK: - MyPage
    
    static let badgesListURL = "/members/badges"
    static let myPageURL = "/members/me"
    
    // MARK: - Diary
    
    static let diaryURL = "/diaries"
    
    // MARK: - Correction
    
    static let correctionPostURL = "/corrections/diary"
    static let correctionURL = "/corrections"
    
    // MARK: - RandomSubject
    
    static let randomSubjectURL = "/topics/random"
    
    // MARK: - Push
    
    static let pushURL = "/members/push"
    
    // MARK: - Papago
    
    static let papagoBaseURL = "https://openapi.naver.com"
    static let papagoPathURL = "/v1/papago/n2mt"
}
