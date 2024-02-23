//
//  MockProvider.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/20/24.
//

import Foundation
import Moya

protocol MockProviderProtocol {
    associatedtype TargetEndPoint: TargetType
    func makeSuccessProvider() -> MoyaProvider<TargetEndPoint>
}

extension MockProviderProtocol {
    func makeSuccessProvider() -> MoyaProvider<TargetEndPoint> {
        let endpointClosure = { (target: TargetEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<TargetEndPoint>(endpointClosure: endpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }
    
    func makeFailureProvider() -> MoyaProvider<TargetEndPoint> {
        let endpointClosure = { (target: TargetEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<TargetEndPoint>(endpointClosure: endpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }
}
