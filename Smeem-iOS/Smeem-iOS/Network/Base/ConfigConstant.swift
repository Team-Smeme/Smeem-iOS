//
//  SharedConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

enum ConfigConstant {
    
    static let version: String = {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "VERSION") as? String else {
            fatalError("version typecasting failed")
        }
        return version
    }()
    
    // MARK: - kakao key
    static let nativeAppKey: String = {
        guard let nativeAppkey = Bundle.main.object(forInfoDictionaryKey: "NATIVE_APP_KEY") as? String else {
            fatalError("nativeAppkey typecasting failed")
        }
        return nativeAppkey
    }()
    
    // MARK: - Base URL
    static let serverURL: String = {
        guard let serverURL = Bundle.main.object(forInfoDictionaryKey: "SERVER_URL") as? String else {
            fatalError("server url typecasting failed")
        }
        return serverURL
    }()
    
    static let papagoID: String = {
        guard let papagoID = Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_ID") as? String else {
            fatalError("papago id typecasting failed")
        }
        return papagoID
    }()
    
    static let papagoSecret: String = {
        guard let papagoSecret = Bundle.main.object(forInfoDictionaryKey: "X_NAVER_CLIENT_SECRET") as? String else {
            fatalError("papago password typecasting failed")
        }
        return papagoSecret
    }()
    
    static let deepLID: String = {
        guard let deepLID = Bundle.main.object(forInfoDictionaryKey: "DEEPL_CLIENT_ID") as? String else {
            fatalError("deepL id typecasting failed")
        }
        return deepLID
    }()
    
    static let deepLSecret: String = {
        guard let deepLSecret = Bundle.main.object(forInfoDictionaryKey: "DEEPL_CLLIENT_SECRET") as? String else {
            fatalError("deepL password typecasting failed")
        }
        return deepLSecret
    }()
}
