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
    private var loginResponse: LoginResponse?
    
    func loginAPI(param: LoginRequest, completion: @escaping ((LoginResponse)?) -> Void) {
        authProvider.request(.login(param: param)) { response in
            switch response {
            case .success(let result):
                guard let response = try? result.map(LoginResponse.self) else { return }
                completion(response)
            case .failure(let err):
                print(err)
            }
        }
    }
}
