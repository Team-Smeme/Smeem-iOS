//
//  CoachingServiceProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/24/24.
//

import Foundation

protocol CoachingServiceProtocol {
    func coachingPostAPI(diaryID: Int) async throws -> CoachingsResponse
    func detailDiaryAPI(diaryID: Int) async throws -> DetailDiaryResponse
}
