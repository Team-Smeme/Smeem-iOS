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
    private var loginResponse: GeneralResponse<LoginResponse>?
    
    func loginAPI(param: LoginRequest, completion: @escaping (GeneralResponse<LoginResponse>) -> Void) {
        authProvider.request(.login(param: param)) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<LoginResponse>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func reLoginAPI(completion: @escaping (GeneralResponse<ReLoginResponse>) -> Void) {
        authProvider.request(.reLogin) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<ReLoginResponse>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func logoutAPI(completion: @escaping (GeneralResponse<VoidType>) -> Void) {
        authProvider.request(.logout) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<VoidType>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func resignAPI(completion: @escaping (GeneralResponse<VoidType>) -> Void) {
        authProvider.request(.resign) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<VoidType>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
