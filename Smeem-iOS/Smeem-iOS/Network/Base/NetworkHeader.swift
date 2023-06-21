//
//  NetworkConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

enum NetworkConstant {    
    static let tempTokenHeader = ["Content-Type": "application/json",
                                  "Authorization": SharedConstant.tempToken]
//    static let betaTestHeader = ["Content-Type": "application/json",
//                                "Authorization": tempToken]
    static let papagoHeader = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                               "X-Naver-Client-Id": SharedConstant.papagoID,
                               "X-Naver-Client-Secret": SharedConstant.papagoSecret]
}
