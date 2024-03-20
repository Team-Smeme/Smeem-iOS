//
//  SplashServiceMock.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 3/20/24.
//

import XCTest

@testable import Smeem_iOS

final class SplashServiceMock: XCTestCase, SplashServiceProtocol {
    func updateGetAPI(completion: @escaping (Result<Smeem_iOS.UpdateResponse, Smeem_iOS.SmeemError>) -> ()) {
        completion(.success(UpdateResponse(title: "업데이트",
                                           content: "업데이트 해주세요",
                                           iosVersion: iOSVersion(version: "2.0.0",
                                                                  forceVersion: "3.0.0"))))
    }
}
