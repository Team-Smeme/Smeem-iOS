//
//  MyPageAPI.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

import Moya

public class MyPageAPI {
    static let shared = MyPageAPI()
    var myPageProvider = MoyaProvider<MyPageService>(plugins: [MoyaLoggingPlugin()])
    
    private var myPageInfo: GeneralResponse<MyPageInfo>?
    private var badgeList: GeneralResponse<BadgeListResponse>?
    
    func myPageInfo(completion: @escaping (GeneralResponse<MyPageInfo>?) -> Void) {
        myPageProvider.request(.MyPageInfo) { response in
            switch response {
            case .success(let result):
                do {
                    self.myPageInfo = try result.map(GeneralResponse<MyPageInfo>.self)
                    completion(self.myPageInfo)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func changeMyNickName(userName: String, completion: @escaping (GeneralResponse<String>?) -> Void) {
        myPageProvider.request(.ChangeMyNickName(param: NicknameRequest(username: userName))) { response in
            switch response {
            case .success(_):
                print(response)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func badgeListAPI(completion: @escaping (GeneralResponse<BadgeListResponse>?) -> Void) {
        myPageProvider.request(.badgeList) { response in
            switch response {
            case .success(let result):
                guard let badgeList = try? result.map(GeneralResponse<BadgeListResponse>.self) else { return }
                print("출력이 되나요?", badgeList)
                completion(badgeList)
            case .failure(let err):
                print(err)
            }
        }
    }
}
