//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleRightNavitationButton()
    }
    
    private func handleRightNavitationButton() {
        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            //TODO: HomeView로 돌아가는 코드
            postDiaryAPI()
        } else {
            view.addSubview(regExToastView)
            regExToastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top).offset(-20)
            }
            regExToastView.show()
        }
    }
}

extension ForeignDiaryViewController {
    func postDiaryAPI() {
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputTextView.text, topicId: topicID)) { response in
            guard let postDiaryResponse = response?.data else { return }
//            self.diaryID = postDiaryResponse.
        }
    }
}
