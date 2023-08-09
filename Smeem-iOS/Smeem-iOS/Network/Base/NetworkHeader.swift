//
//  NetworkConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

enum NetworkConstant {
    
    static let tempTokenHeader = ["Content-Type": "application/json",
                                  "Authorization": "Bearer "]
    
    static let hasSocialTokenHeader = ["Content-Type": "application/json",
                                 "Authorization": "Bearer "+(UserDefaultsManager.socialToken)]
    
    static let hasAccessTokenHeader = ["Content-Type": "application/json",
                                       "Authorization": "Bearer "+(UserDefaultsManager.accessToken)]
    
    static let hasRefreshTokenHeader = ["Content-Type": "application/json",
                                        "Authorization": "Bearer "+(UserDefaultsManager.refreshToken)]
    
    static let noTokenHeader = ["Content-Type": "application/json",
                                  "Authorization": ""]
    
    static let papagoHeader = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                               "X-Naver-Client-Id": SharedConstant.papagoID,
                               "X-Naver-Client-Secret": SharedConstant.papagoSecret]
}
