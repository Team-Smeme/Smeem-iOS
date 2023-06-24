//
//  OnboardingAPI.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/24.
//

import Foundation
import Moya

public class OnboardingAPI {
    
    static let shared = OnboardingAPI()
    private let onboardingProvider = MoyaProvider<OnboardingService>(plugins: [MoyaLoggingPlugin()])
    private var nicknameResponse: NicknameResponse?
    
    func nicknamePatch(param: NicknameRequest, completion: @escaping ((NicknameResponse)) -> Void) {
        onboardingProvider.request(.nickname(param: param)) { response in
            print(response)
            switch response {
            case .success(let result):
                guard let data = try? result.map(NicknameResponse.self) else { return }
                completion(data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
