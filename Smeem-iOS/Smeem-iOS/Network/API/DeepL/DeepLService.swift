//
//  DeepLService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/01/15.
//

import Foundation

import Moya

struct DeepLService: TargetType {
    var baseURL: URL = URL(string: URLConstant.deepLBaseURL)!
    
    var path: String = URLConstant.deepLPathURL
    
    var method: Moya.Method = .post
    
    var task: Moya.Task
    
    var headers: [String : String]?
    
    init(text: String, authToken: String) {
        self.task = .requestParameters(parameters: ["text": text, "target_lang": "EN", "auth_key": authToken], encoding: URLEncoding.default)
    }
}
