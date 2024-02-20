//
//  MockProvider.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/20/24.
//

import Foundation
import Moya

protocol MockProviderProtocol {
    associatedtype targetEndPoint: TargetType
    func makeProvider() -> MoyaProvider<targetEndPoint>
}

extension MockProviderProtocol {
    func makeProvider() -> MoyaProvider<targetEndPoint> {
        let endpointClosure = { (target: targetEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<targetEndPoint>(endpointClosure: endpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }
}
