//
//  TrainingDataSendProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/09.
//

import Foundation

protocol TrainingDataSendDelegate {
    func sendButtonState()
    func sendTargetString(targetString: String)
}
