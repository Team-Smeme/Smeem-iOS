//
//  SettingServiceProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import Foundation

protocol SettingServiceProtocol {
    func settingGetAPI(completion: @escaping (Result<SettingResponse, SmeemError>) -> ())
    func editPushAPI(param: EditPushRequest,
                     completion: @escaping (Result<GeneralResponse<NilType>, SmeemError>) -> ())
}
