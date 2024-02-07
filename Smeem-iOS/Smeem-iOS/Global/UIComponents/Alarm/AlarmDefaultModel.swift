//
//  AlarmDefaultModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/07.
//

import Foundation

struct AlarmDefaultModel {
    static let dayArray = ["월", "화", "수", "목", "금", "토", "일"]
    static let selectedIndexPath = [IndexPath(item: 0, section: 0),
                             IndexPath(item: 1, section: 0),
                             IndexPath(item: 2, section: 0),
                             IndexPath(item: 3, section: 0),
                             IndexPath(item: 4, section: 0)]
    static let dayDicrionary: [String:String] = ["월": "MON",
                                          "화": "TUE",
                                          "수": "WED",
                                          "목": "THU",
                                          "금": "FRI",
                                          "토": "SAT",
                                          "일": "SUN"]
}
