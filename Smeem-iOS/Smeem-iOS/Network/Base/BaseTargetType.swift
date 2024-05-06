//
//  BaseTargetType.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

import Moya

enum ServerVersion {
    case v2
    case v3
}

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: ConfigConstant.serverURLV2)!
    }
    
    var sampleData: Data {
        return Data()
    }
}
