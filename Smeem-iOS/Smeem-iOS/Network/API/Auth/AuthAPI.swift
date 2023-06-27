//
//  AuthAPI.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation
import Moya

public class AuthAPI {
    
    static let shared = AuthAPI()
    private let authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggingPlugin()])
    private var betaTestResponse: BetaTestResponse?
    
    func betaTestLoginAPI(completion: @escaping (GeneralResponse<BetaTestResponse>) -> Void) {
        authProvider.request(.beta) { response in
            switch response {
            case .success(let result):
                guard let token = try? result.map(GeneralResponse<BetaTestResponse>.self) else { return }
                completion(token)
            case .failure(let err):
                print(err)
            }
        }
    }
}
