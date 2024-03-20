//
//  SplashServiceProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/20/24.
//

import Foundation

protocol SplashServiceProtocol {
    func updateGetAPI(completion: @escaping (Result<UpdateResponse, SmeemError>) -> ())
}
