//
//  HomeAPI.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/26.
//

import Foundation

import Moya

public class HomeAPI {
    static let shared = HomeAPI()
    var homeProvider = MoyaProvider<HomeService>(plugins: [MoyaLoggingPlugin()])
    private var homeDiaryListData: GeneralResponse<HomeDiaryResponse>?
    
    func homeDiaryList(startDate: String, endDate: String, completion: @escaping (GeneralResponse<HomeDiaryResponse>?) -> Void) {
        homeProvider.request(.HomeDiary(startDate: startDate, endDate: endDate)) { response in
            switch response {
            case .success(let result):
                do {
                    self.homeDiaryListData = try result.map(GeneralResponse<HomeDiaryResponse>.self)
                    completion(self.homeDiaryListData)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
