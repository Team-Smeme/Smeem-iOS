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
    
//    func reLoginAPI(completion: @escaping (Result<ReLoginResponse, Error>) -> ()) {
//        authProvider.request(.reLogin) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    guard let data = try response.map(GeneralResponse<ReLoginResponse>.self).data else { return }
//                    completion(.success(data))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func reLoginAPI(completion: @escaping (GeneralResponse<ReLoginResponse>) -> ()) {
        authProvider.request(.reLogin) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(GeneralResponse<ReLoginResponse>.self) else {
                    print("에러")
                    return
                }
                completion(data)
            case .failure(let error):
                print(error)
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
