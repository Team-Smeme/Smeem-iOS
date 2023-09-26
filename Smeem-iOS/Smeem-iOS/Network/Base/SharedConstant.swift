//
//  SharedConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

enum SharedConstant {
    
    // MARK: - kakao key
    static let nativeAppKey = Bundle.main.object(forInfoDictionaryKey: "NATIVE_APP_KEY") as? String ?? ""
    
    // MARK: - Base URL
    static let devBaseURL = Bundle.main.object(forInfoDictionaryKey: "DEV_BASE_URL") as? String ?? ""
    static let proBaseURL = Bundle.main.object(forInfoDictionaryKey: "PRO_BASE_URL") as? String ?? ""
    
    // MARK: - token
    static let tempToken = Bundle.main.object(forInfoDictionaryKey: "TEMP_TOKEN") as? String ?? ""
    
    // MARK: - papago
    static let papagoID = Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_ID") as? String ?? ""
    static let papagoSecret = Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_SECRET") as? String ?? ""
}
