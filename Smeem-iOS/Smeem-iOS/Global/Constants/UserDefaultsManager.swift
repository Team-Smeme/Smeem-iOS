//
//  UserDefaultsManager.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/07.
//

import Foundation

struct UserDefaultsManager {
    static var tutorialWeeklyTwoMode: Bool {
        get { return UserDefaults.standard.bool(forKey: "tutorialWeeklyTwoMode")}
        set { UserDefaults.standard.set(newValue, forKey: "tutorialWeeklyTwoMode")}
    }
    
    static var tutorialDiaryStepOne: Bool {
        get { return UserDefaults.standard.bool(forKey: "tutorialDiaryStepOne")}
        set { UserDefaults.standard.set(newValue, forKey: "tutorialDiaryStepOne")}
    }
    
    static var tutorialDiaryStepTwo: Bool {
        get { return UserDefaults.standard.bool(forKey: "tutorialDiaryStepTwo")}
        set { UserDefaults.standard.set(newValue, forKey: "tutorialDiaryStepTwo")}
    }
    
    static var tutorialWeeklyCorrection: Bool {
        get { return UserDefaults.standard.bool(forKey: "tutorialWeeklyCorrection")}
        set { UserDefaults.standard.set(newValue, forKey: "tutorialWeeklyCorrection")}
    }
    
    static var betaLoginToken: String {
        get { return UserDefaults.standard.string(forKey: "betaToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "betaToken")}
    }
    
    static var isShownWelcomeBadgePopup: Bool {
        get { return UserDefaults.standard.bool(forKey: "isShownWelcomeBadgePopup")}
        set { UserDefaults.standard.set(newValue, forKey: "isShownWelcomeBadgePopup")}
    }
    
    static var socialToken: String {
        get { return UserDefaults.standard.string(forKey: "socialToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "socialToken")}
    }
    
    static var accessToken: String {
        get { return UserDefaults.standard.string(forKey: "accessToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "accessToken")}
    }
    
    static var refreshToken: String {
        get { return UserDefaults.standard.string(forKey: "refreshToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "refreshToken")}
    }
    
    static var fcmToken: String {
        get { return UserDefaults.standard.string(forKey: "fcmToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "fcmToken")}
    }
    
    static var clientAccessToken: String {
        get { return UserDefaults.standard.string(forKey: "clientToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "clientToken")}
    }
    
    static var clientRefreshToken: String {
        get { return UserDefaults.standard.string(forKey: "clientRefreshToken") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "clientRefreshToken")}
    }
    
    static var clientAuthType: String {
        get { return UserDefaults.standard.string(forKey: "clientAuthType") ?? ""}
        set { UserDefaults.standard.set(newValue, forKey: "clientAuthType")}
    }
    
    static var hasKakaoToken: Bool? {
        get { return UserDefaults.standard.bool(forKey: "hasKakaoToken")}
        set { UserDefaults.standard.set(newValue, forKey: "hasKakaoToken")}
    }
    
    static var randomSubjectToolTip: Bool {
        get { return UserDefaults.standard.bool(forKey: "randomSubjectToolTip")}
        set { UserDefaults.standard.set(newValue, forKey: "randomSubjectToolTip")}
    }
    
    static var tipView: Bool {
        get { return UserDefaults.standard.bool(forKey: "tipView")}
        set { UserDefaults.standard.set(newValue, forKey: "tipView")}
    }
}
