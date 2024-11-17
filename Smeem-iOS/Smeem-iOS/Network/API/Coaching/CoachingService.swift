//
//  CoachingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import Foundation
import Moya

final class CoachingService {
    
    static let shared = CoachingService()
    private let provider = MoyaProvider<CoachingEndPoint>(plugins: [MoyaLoggingPlugin()])
    
    func coachingPostAPI(diaryId: Int) async throws -> CoachingsResponse {
        let result = await self.provider.request(.coaching(diaryId: diaryId))
        
        switch result {
        case .success(let response):
            do {
                try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                guard let data = try? response.map(GeneralResponse<CoachingsResponse>.self).data else {
                    throw SmeemError.clientError
                }
                return data
            } catch let error {
                if let smeemError = error as? SmeemError {
                    throw smeemError
                } else {
                    throw SmeemError.unknwnError
                }
            }
        case .failure(_):
            throw SmeemError.userError
        }
    }
}
