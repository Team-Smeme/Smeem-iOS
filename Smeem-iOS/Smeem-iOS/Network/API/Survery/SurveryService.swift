//
//  SurveryService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/30/25.
//

import Foundation
import Moya

final class SurveryService {
    static let shared = SurveryService()
    private let surveryProvider = MoyaProvider<CoachingEndPoint>(plugins: [MoyaLoggingPlugin()])
    
    func surveyPostAPI(request: SurveyRequest) async throws -> GeneralResponse<NilType> {
        try await surveryProvider.requestNilType(.survey(request: request))
    }
}
