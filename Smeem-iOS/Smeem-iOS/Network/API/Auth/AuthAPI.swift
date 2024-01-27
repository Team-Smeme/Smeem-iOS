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
    
    func loginAPI(param: LoginRequest, completion: @escaping (Result<LoginResponse, SmeemError>) -> ()) {
        authProvider.request(.login(param: param)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    guard let data = try response.map(GeneralResponse<LoginResponse>.self).data else { return }
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
    
    func reLoginAPI(completion: @escaping (Result<GeneralResponse<ReLoginResponse>, SmeemError>) -> ()) {
        authProvider.request(.reLogin) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    guard let data = try response.map(GeneralResponse<ReLoginResponse>?.self) else { return }
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
    
    func logoutAPI(completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        authProvider.request(.logout) { response in
            switch response {
            case .success(let result):
                let statusCode = result.statusCode
                
                do {
                    // 서버 통신 성공, 실패 모두 data nil 값
                    guard let data = try result.map(GeneralResponse<NilType>?.self) else { return }
                    
                    // 서버 통신은 성공했지만, 실패일 경우
                    if data.success == false {
                        throw NetworkManager.statusCodeErrorHandling(statusCode: statusCode)
                    }
                    
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
    
    func resignAPI(completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        authProvider.request(.resign) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    guard let data = try response.map(GeneralResponse<NilType>?.self) else { return }
                    
                    if data.success == false {
                        throw NetworkManager.statusCodeErrorHandling(statusCode: statusCode)
                    }
                    
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
}
