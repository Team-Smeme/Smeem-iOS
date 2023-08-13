//
//  NextButtonDelegate.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/12.
//

protocol NextButtonDelegate: AnyObject {
    func nextButtonDidTap()
    
    //TODO: 네비게이션 바 추상화 후 NavbarProtocol으로 이동
    func backButtonDidTap()
}
