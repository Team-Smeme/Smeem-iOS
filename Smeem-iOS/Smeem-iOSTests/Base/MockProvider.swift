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
    func makeFailure400Provider() -> MoyaProvider<TargetEndPoint>
    func makeFailure500Provider() -> MoyaProvider<TargetEndPoint>
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
    
    func makeFailure400Provider() -> MoyaProvider<TargetEndPoint> {
        let endpointClosure = { (target: TargetEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(400, Data()) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<TargetEndPoint>(endpointClosure: endpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }
    
    func makeFailure500Provider() -> MoyaProvider<TargetEndPoint> {
        let endpointClosure = { (target: TargetEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(500, Data()) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<TargetEndPoint>(endpointClosure: endpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }
}
