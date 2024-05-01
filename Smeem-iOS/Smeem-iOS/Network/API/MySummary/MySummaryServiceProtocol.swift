//
//  MySummaryProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/27/24.
//

import Foundation

protocol MySummaryServiceProtocol {
    func mySummaryGetAPI(completion: @escaping (Result<MySummaryResponse, SmeemError>) -> ())
    func myPlanGetAPI(completion: @escaping (Result<GeneralResponse<MyPlanResponse>, SmeemError>) -> ())
//    func myBadgeGetAPI(completion: @escaping (Result<[Goal], SmeemError>) -> ())
}
