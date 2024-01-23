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
    
    func reLoginAPI(completion: @escaping (Result<GeneralResponse<ReLoginResponse>, SmeemErrorMessage>) -> ()) {
        authProvider.request(.reLogin) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    let data = try response.map(GeneralResponse<ReLoginResponse>.self)
                    completion(.success(data))
                } catch {
                    let error = NetworkManager.statusCodeErrorHandling(statusCode: statusCode)
                    completion(.failure(error))
                }
                
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
    
    func logoutAPI(completion: @escaping (GeneralResponse<NilType>) -> Void) {
        authProvider.request(.logout) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<NilType>.self) else {
                    print("⭐️⭐️⭐️ 디코더 에러 ⭐️⭐️⭐️")
                    return
                }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func resignAPI(completion: @escaping (GeneralResponse<NilType>) -> Void) {
        authProvider.request(.resign) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(GeneralResponse<NilType>.self) else {
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
