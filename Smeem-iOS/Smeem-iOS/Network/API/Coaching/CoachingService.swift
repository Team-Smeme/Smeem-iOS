//
//  CoachingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/24/24.
//

import Foundation
import Moya

final class CoachingService: CoachingServiceProtocol {

    var coachingProvider: MoyaProvider<CoachingEndPoint>!
    var detailDiaryProvider: MoyaProvider<DetailDiaryEndPoint>
    
    init(coachingProvider: MoyaProvider<CoachingEndPoint> = MoyaProvider<CoachingEndPoint>(plugins: [MoyaLoggingPlugin()]),
         detailDiaryProvider: MoyaProvider<DetailDiaryEndPoint> = MoyaProvider<DetailDiaryEndPoint>(plugins: [MoyaLoggingPlugin()])) {
        self.coachingProvider = coachingProvider
        self.detailDiaryProvider = detailDiaryProvider
    }
    
    func coachingPostAPI(diaryID: Int) async throws -> CoachingsResponse {
        let result: CoachingsResponse = try await coachingProvider.request(CoachingEndPoint.coaching(diaryId: diaryID))
        return result
    }
    
    func detailDiaryAPI(diaryID: Int) async throws -> DetailDiaryResponse {
        let result: DetailDiaryResponse = try await detailDiaryProvider.request(DetailDiaryEndPoint.detailDiary(diaryID: diaryID))
        return result
    }
}

