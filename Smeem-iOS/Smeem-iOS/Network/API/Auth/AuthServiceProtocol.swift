//
//  AuthServiceProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/30/24.
//

import Foundation

protocol AuthServiceProtocol {
    func loginAPI(param: LoginRequest, completion: @escaping (Result<LoginResponse, SmeemError>) -> ())
    func reLoginAPI(completion: @escaping (Result<GeneralResponse<ReLoginResponse>, SmeemError>) -> ())
    func logoutAPI(completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ())
    func resignAPI(request: ResignRequest, completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ())
}
