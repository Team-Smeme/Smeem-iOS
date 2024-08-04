//
//  AuthEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation
import Moya

public class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    private let authProvider = MoyaProvider<AuthEndPoint>(plugins: [MoyaLoggingPlugin()])
    
    var provider: MoyaProvider<AuthEndPoint>!
    
    init(provider: MoyaProvider<AuthEndPoint> = MoyaProvider<AuthEndPoint>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func loginAPI(param: LoginRequest, completion: @escaping (Result<LoginResponse, SmeemError>) -> ()) {
        authProvider.request(.login(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try response.map(GeneralResponse<LoginResponse>.self).data else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch {
                    guard let error = error as? SmeemError else { return }
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
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<ReLoginResponse>.self) else {
                        throw SmeemError.clientError
                    }
                    completion(.success(data))
                } catch {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
                
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
    
    func logoutAPI(completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        authProvider.request(.logout) { result in
            switch result {
            case .success(let response):
                do {
                    // 서버 통신 성공, 실패 모두 data nil 값
                    try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
                    guard let data = try? response.map(GeneralResponse<NilType>.self) else {
                        throw SmeemError.clientError
                    }
                    
                    // 서버 통신은 성공했지만, 실패일 경우
                    if data.success == false {
                        throw SmeemError.clientError
                    }
                    
                    completion(.success(data))
                } catch {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
    
    func resignAPI(request: ResignRequest, completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ()) {
        authProvider.request(.resign(body: request)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                do {
                    try NetworkManager.statusCodeErrorHandling(statusCode: statusCode)
                    guard let data = try? response.map(GeneralResponse<NilType>.self) else {
                        throw SmeemError.clientError
                    }
                    
                    if data.success == false {
                        throw SmeemError.clientError
                    }
                    
                    completion(.success(data))
                } catch {
                    guard let error = error as? SmeemError else { return }
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.userError))
            }
        }
    }
}
