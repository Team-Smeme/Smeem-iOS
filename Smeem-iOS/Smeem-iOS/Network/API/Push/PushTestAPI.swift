//
//  PushTestAPI.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/05.
//

import Moya

final class PushTestAPI {
    static let shared = PushTestAPI()
    private let pushTestProvider = MoyaProvider<PushTestService>(plugins: [MoyaLoggingPlugin()])
    
    func getPustTest(completion: @escaping (GeneralResponse<VoidType>?) -> Void) {
        pushTestProvider.request(.pushTest) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<VoidType>.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
