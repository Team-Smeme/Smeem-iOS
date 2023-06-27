//
//  DetailDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    
    // MARK: - Property
    
    var diaryContent = String()
    var isRandomTopic = String()
    var dateCreated = String()
    var userName = String()
    
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
        detailDiaryWithAPI()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setData() {
        diaryScrollerView.configureDiaryScrollerView(contentText: diaryContent, date: dateCreated, nickname: userName)
    }
    
    // MARK: - Layout
    
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
}

//MARK: - Network

extension DetailDiaryViewController {
    func detailDiaryWithAPI() {
        DetailDiaryAPI.shared.getDetailDiary { response in
            guard let detailDiaryData = response?.data else { return }
            self.isRandomTopic = detailDiaryData.topic
            self.diaryContent = detailDiaryData.content
            self.dateCreated = detailDiaryData.createdAt
            self.userName = detailDiaryData.username
            self.setData()
        }
    }
}
