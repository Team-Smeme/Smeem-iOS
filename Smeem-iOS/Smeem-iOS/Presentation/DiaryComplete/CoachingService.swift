////
////  CoachingService.swift
////  Smeem-iOS
////
////  Created by 황찬미 on 11/18/24.
////
//
//import Foundation
//import ComposableArchitecture
//import Moya
//
//extension DependencyValues {
//    var coachingService: CoachingService {
//        get { self[CoachingServiceKey.self] }
//        set { self[CoachingServiceKey.self] = newValue}
//    }
//}
//
//struct CoachingServiceKey: DependencyKey {
//    static var liveValue: CoachingService = CoachingServiceLive()
//}
//
//protocol CoachingService {
//    func coachingPostAPI(diaryID: Int) async throws -> CoachingsResponse
//    func detailDiaryAPI(diaryID: Int) async throws -> DetailDiaryResponse
//}
//
//final class CoachingServiceLive: CoachingService {
//    func coachingPostAPI(diaryID: Int) async throws -> CoachingsResponse {
//        let result: CoachingsResponse = try await ServiceNetwork.shared.request(CoachingEndPoint.coaching(diaryId: diaryID))
//        return result
//    }
//    
//    func detailDiaryAPI(diaryID: Int) async throws -> DetailDiaryResponse {
//        let result: DetailDiaryResponse = try await ServiceNetwork.shared.request(DetailDiaryEndPoint.detailDiary(diaryID: diaryID))
//        return result
//    }
//}
