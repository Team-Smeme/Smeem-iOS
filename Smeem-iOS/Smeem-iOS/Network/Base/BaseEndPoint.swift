//
//  BaseEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/21.
//

import Foundation

/// end point를 작성할 때 채택해 주어야 하는 프로토콜

protocol BaseEndPoint {
    
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var query: [String:String]? { get }
    var requestBody: Data? { get }
    var header: [String:String] { get }
    
    func makeUrlRequest() -> NetworkRequest
}
