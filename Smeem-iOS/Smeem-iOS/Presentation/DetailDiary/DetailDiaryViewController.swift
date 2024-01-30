//
//  DetailDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import UIKit

import SnapKit

final class DetailDiaryViewController: BaseViewController {
    
    // MARK: - Property
    
    var diaryContent = String()
    var isRandomTopic = String()
    var dateCreated = String()
    var userName = String()
    var diaryId = Int()
    
    // MARK: - UI Property
    
    private var naviView: SmeemNavigationBar = NavigationBarFactory.create(type: .detail)
    
    let diaryScrollerView: DiaryScrollerView = {
        let scrollerView = DiaryScrollerView()
        return scrollerView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        swipeRecognizer()
        setDelegate()
        
        AmplitudeManager.shared.track(event: AmplitudeConstant.diaryDetail.mydiary_click.event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailDiaryWithAPI(diaryID: diaryId)
    }
    
    // MARK: - @objc
    
    @objc func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction (title: "수정", style: .default, handler: { (action) in
            AmplitudeManager.shared.track(event: AmplitudeConstant.diaryDetail.mydiary_edit.event)
            let editVC = EditDiaryViewController()
            editVC.diaryID = self.diaryId
            editVC.randomContent = self.isRandomTopic
            editVC.diaryTextView.text = self.diaryContent
            editVC.randomSubjectView.setData(contentText: self.isRandomTopic)
            self.navigationController?.pushViewController(editVC, animated: true)
        })
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
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Custom Method
    
    func setData() {
        diaryScrollerView.configureDiaryScrollerView(topic: isRandomTopic, contentText: diaryContent, date: dateCreated, nickname: userName)
    }
    
    private func setScrollerViewType() {
        if isRandomTopic == "" {
            diaryScrollerView.viewType = .detailDiary
        } else if isRandomTopic != "" {
            diaryScrollerView.viewType = .detailDiaryHasRandomSubject
        }
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(naviView, diaryScrollerView)
        
        naviView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        diaryScrollerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        naviView.actionDelegate = self
    }
}

// MARK: - NavigationBarActionDelegate

extension DetailDiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapRightButton() {
        showActionSheet()
    }
}

//MARK: - Network

extension DetailDiaryViewController {
    
    func detailDiaryWithAPI(diaryID: Int) {
        SmeemLoadingView.showLoading()
        
        DetailDiaryAPI.shared.getDetailDiary(diaryID: diaryId) { result in
            
            switch result {
            case .success(let response):
                self.isRandomTopic = response.topic
                self.diaryContent = response.content
                self.dateCreated = response.createdAt
                self.userName = response.username
                self.setData()
                self.setScrollerViewType()
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
    
    func deleteDiaryWithAPI(diaryID: Int) {
        SmeemLoadingView.showLoading()
        
        DetailDiaryAPI.shared.deleteDiary(diaryID: diaryId) { result in
            
            switch result {
            case .success(_):
                let homeVC = HomeViewController()
                let rootVC = UINavigationController(rootViewController: homeVC)
                self.changeRootViewControllerAndPresent(rootVC)
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
