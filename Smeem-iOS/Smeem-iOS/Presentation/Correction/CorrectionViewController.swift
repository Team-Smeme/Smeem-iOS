//
//  CorrectionViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/21.
//

import UIKit

final class CorrectionViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .point
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .point
        return button
    }()
    
    private let diaryScrollerView: DiaryScrollerView = {
        let scrollerView = DiaryScrollerView()
        scrollerView.viewType = .detailDiary
        return scrollerView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(naviView, diaryScrollerView)
        naviView.addSubviews(backButton, editButton)
        
        naviView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        diaryScrollerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    
    // MARK: - Layout
}
