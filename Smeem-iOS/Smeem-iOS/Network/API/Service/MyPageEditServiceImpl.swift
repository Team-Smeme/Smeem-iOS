//
//  MyPageEditServiceImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/26.
//

import Foundation

protocol MyPageEditService {
    func editNickname(model: EditNicknameRequest) async throws -> BaseResponse<NilType>?
    func editGoal(model: EditGoalRequest) async throws -> BaseResponse<NilType>?
    func editPush(model: EditPushRequest) async throws -> BaseResponse<NilType>?
    func editAlarmTime(model: EditAlarmTime) async throws -> BaseResponse<NilType>?
}

struct MyPageEditServiceImpl: MyPageEditService {
    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func editNickname(model: EditNicknameRequest) async throws -> BaseResponse<NilType>? {
        let urlReqeust = MyPageEditEndPoint.editNickName(model: model).makeUrlRequest()
        return try await requestable.request(urlReqeust)
    }
    
    func editGoal(model: EditGoalRequest) async throws -> BaseResponse<NilType>? {
        let urlReqeust = MyPageEditEndPoint.editGoal(model: model).makeUrlRequest()
        return try await requestable.request(urlReqeust)
    }
    
    func editPush(model: EditPushRequest) async throws -> BaseResponse<NilType>? {
        let urlReqeust = MyPageEditEndPoint.editPush(model: model).makeUrlRequest()
        return try await requestable.request(urlReqeust)
    }
    
    func editAlarmTime(model: EditAlarmTime) async throws -> BaseResponse<NilType>? {
        let urlReqeust = MyPageEditEndPoint.editAlarmTime(model: model).makeUrlRequest()
        return try await requestable.request(urlReqeust)
    }
}
