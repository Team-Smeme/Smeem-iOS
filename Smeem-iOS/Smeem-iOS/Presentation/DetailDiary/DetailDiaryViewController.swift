//
//  DetailDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import UIKit

import SnapKit

final class DetailDiaryViewController: UIViewController {
    
    // MARK: - Property
    
    var diaryContent = String()
    var isRandomTopic = String()
    var dateCreated = String()
    var userName = String()
    var diaryId = Int()
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnMore, for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
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
        detailDiaryWithAPI(diaryID: diaryId)
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction (title: "수정", style: .default, handler: nil)
        let deleteAction = UIAlertAction (title: "삭제", style: .destructive, handler: { (action) in
            self.showAlert()
        })
        let cancelAction = UIAlertAction (title: "취소", style: .cancel, handler: nil)
        alert.addAction (modifyAction)
        alert.addAction (deleteAction)
        alert.addAction (cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func showAlert() {
        let alert = UIAlertController(title: "일기를 삭제할까요?", message: "", preferredStyle: .alert)
        let delete = UIAlertAction(title: "확인", style: .destructive) { (action) in
            self.deleteDiaryWithAPI(diaryID: self.diaryId)
            self.changeRootViewControllerAndPresent(HomeViewController())
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        diaryScrollerView.configureDiaryScrollerView(contentText: diaryContent, date: dateCreated, nickname: userName)
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
        hiddenNavigationBar()
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
    func detailDiaryWithAPI(diaryID: Int) {
        DetailDiaryAPI.shared.getDetailDiary(diaryID: diaryId) { response in
            guard let detailDiaryData = response?.data else { return }
            self.isRandomTopic = detailDiaryData.topic
            self.diaryContent = detailDiaryData.content
            self.dateCreated = detailDiaryData.createdAt
            self.userName = detailDiaryData.username
            self.setData()
        }
    }
    
    func deleteDiaryWithAPI(diaryID: Int) {
        DetailDiaryAPI.shared.deleteDiary(diaryID: diaryId) { _ in
        }
    }
}
