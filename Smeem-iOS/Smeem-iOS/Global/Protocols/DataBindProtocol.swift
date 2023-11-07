//
//  DataBindProtocol.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/28.
//

import Foundation

protocol DataBindProtocol: AnyObject {
    func dataBind(topicID: String?, inputText: String)
}
