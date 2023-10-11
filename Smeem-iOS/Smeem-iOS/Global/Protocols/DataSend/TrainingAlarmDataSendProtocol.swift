//
//  TrainingAlarmDataSendProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/10.
//

import Foundation

protocol TrainingAlarmDataSendProtocol {
    func sendTrainingDay(day: String, buttonState: SmeemButtonType)
    func sendTrainingTime(hour: Int, minute: Int)
}
