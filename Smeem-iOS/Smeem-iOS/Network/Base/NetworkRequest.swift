//
//  NetworkRequest.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/07.
//

import Foundation

struct NetworkRequest {
    let path: String
    let httpMethod: HttpMethod
    let query: [String: String]?
    let requestBody: Data?
    let headers: [String: String]
    
    init(path: String, httpMethod: HttpMethod, query: [String: String]? = nil, requestBody: Data? = nil, headers: [String : String]) {
        self.path = path
        self.httpMethod = httpMethod
        self.query = query
        self.requestBody = requestBody
        self.headers = headers
    }
    
    /// url request를 return 해 주는 메서드
    func makeUrlRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: SharedConstant.baseURL) else {
            throw NetworkError.urlEncodingError
        }
        
        /// query 있을 경우
        if let query = self.query {
            let queryItem = query.map {
                return URLQueryItem(name: $0.key, value: $0.value)
            }
            urlComponents.queryItems = queryItem
        }
        
        guard let url = urlComponents.url?.appendingPathComponent(self.path) else {
            throw NetworkError.urlEncodingError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = requestBody
        
        return urlRequest
    }
}
