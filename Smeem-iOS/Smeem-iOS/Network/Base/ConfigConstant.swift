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
}
