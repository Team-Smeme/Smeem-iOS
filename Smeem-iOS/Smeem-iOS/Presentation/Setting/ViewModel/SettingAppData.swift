//
//  SettingAppData.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import Foundation

struct SettingAppData: Codable {
    let nickname: String
    let plan: Plans?
    var hasPushAlarm: Bool
    let alarmIndexPath: [IndexPath]
}

extension SettingAppData {
    static let empty = SettingAppData(nickname: "정요니",
                                      plan: nil,
                                      hasPushAlarm: false,
                                      alarmIndexPath: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0),
                                                       IndexPath(item: 2, section: 0), IndexPath(item: 3, section: 0),
                                                       IndexPath(item: 4, section: 0)])
}
