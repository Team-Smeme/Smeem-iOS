//
//  BaseTargetType.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: SharedConstant.proBaseURL)!
    }
    
    var sampleData: Data {
        return Data()
    }
}
