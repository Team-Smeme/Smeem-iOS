//
//  MyPageEditManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/26.
//

import Foundation

protocol MyPageEditManagerProtocol {
    func editNickname(model: EditNicknameRequest) async throws
    func editGoal(model: EditGoalRequest) async throws
    func editPush(model: EditPushRequest) async throws
    func editAlarmTime(model: EditAlarmTime) async throws
}

struct MyPageEditManager: MyPageEditManagerProtocol {

    private let myPageEditService: MyPageEditServiceProtocol
    
    init(myPageEditService: MyPageEditServiceProtocol) {
        self.myPageEditService = myPageEditService
    }
    
    func editNickname(model: EditNicknameRequest) async throws {
        guard let _ = try await myPageEditService.editNickname(model: model) else { return }
    }
    
    func editGoal(model: EditGoalRequest) async throws {
        guard let _ = try await myPageEditService.editGoal(model: model) else { return }
    }
    
    func editPush(model: EditPushRequest) async throws {
        guard let _ = try await myPageEditService.editPush(model: model) else { return }
    }
    
    func editAlarmTime(model: EditAlarmTime) async throws {
        guard let _ = try await myPageEditService.editAlarmTime(model: model) else { return }
    }
}
