//
//  DetailDiaryAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

final class DetailDiaryAPI {
    static let shared = DetailDiaryAPI()
    private let detailDiaryProvider = MoyaProvider<DetailDiaryService>(plugins:[MoyaLoggingPlugin()])
    
    private var detailDiaryData: DetailDiaryResponse?
    
    func getDetailDiary(diaryID: Int, complention: @escaping (DetailDiaryResponse?) -> Void) {
        detailDiaryProvider.request(.detailDiary(diaryID: diaryID)) { response in
            switch response {
            case .success(let result):
                do {
                    self.detailDiaryData = try result.map(DetailDiaryResponse.self)
                    complention(self.detailDiaryData)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteDiary(diaryID: Int, complention: @escaping (GeneralResponse<VoidType>?) -> Void) {
        detailDiaryProvider.request(.deleteDiary(diaryID: diaryID)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<VoidType>.self) else { return }
                complention(data)
            case .failure(let err):
                print(err)
            }
        }
        
    }
}
