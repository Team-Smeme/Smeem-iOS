//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

import SnapKit

final class StepTwoKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    var isHintShowed: Bool = false
    var hintText: String?
    
    // MARK: - UI Property
    
    private let hintTextView: UITextView = {
        let textView = UITextView()
        textView.font = .b4
        textView.textContainerInset = .init(top: 16, left: 18, bottom: 16, right: 38)
        textView.scrollIndicatorInsets = .init(top: 16, left: 0, bottom: 16, right: 18)
        textView.isEditable = false
        textView.text = "오늘은 OPR을 공개한 날이었다. 안 떨릴 줄 알았는데 겁나 떨렸당. 사실 카페가 추웠어서 추워서 떠는 건지 긴장 돼서 떠는 건지 구분이 잘 안 갔다. 근데 사실 나는 다리 떠는 것도 습관이라 다리를 떨어서 블라블라블라블라블라블라블라블ㄹ라블라블라블라블라블라블라블라블ㄹ라"
        textView.configureAttributedText()
        return textView
    }()
    
    private let thickLine = SeparationLine(height: .thick)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        handleRightNavitationButton()
        setLayout()
        checkTutorial()
    }
    
    // MARK: - @objc
    
    override func leftNavigationButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            self.hideLodingView(loadingView: self.loadingView)
            postDiaryAPI()
        } else {
            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
    
    @objc override func dismissButtonDidTap() {
        tutorialImageView?.removeFromSuperview()
        dismissButton?.removeFromSuperview()
    }
    
    @objc func hintButtondidTap() {
        isHintShowed.toggle()
        if isHintShowed {
            postPapagoApi(diaryText: hintTextView.text)
            hintButton.setImage(Constant.Image.btnTranslateActive, for: .normal)
        } else {
            hintTextView.text = hintText
            hintButton.setImage(Constant.Image.btnTranslateInactive, for: .normal)
        }
    }
    
    // MARK: - Custom Method
    
    private func handleRightNavitationButton() {
        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(hintTextView,thickLine)
        
        hintTextView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(120))
        }
        
        thickLine.snp.makeConstraints {
            $0.top.equalTo(hintTextView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        inputTextView.snp.remakeConstraints {
            $0.top.equalTo(thickLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func checkTutorial() {
//        let tutorialDiaryStepTwo = UserDefaultsManager.tutorialDiaryStepTwo
//
//        if !tutorialDiaryStepTwo {
//            UserDefaultsManager.tutorialDiaryStepTwo = true
//
//            view.addSubviews(tutorialImageView ?? UIImageView(), dismissButton ?? UIButton())
//
//            tutorialImageView?.snp.makeConstraints {
//                $0.top.leading.trailing.bottom.equalToSuperview()
//            }
//            dismissButton?.snp.makeConstraints {
//                $0.top.equalToSuperview().inset(convertByHeightRatio(371))
//                $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
//                $0.width.height.equalTo(convertByHeightRatio(45))
//            }
//        } else {
//            tutorialImageView = nil
//            dismissButton = nil
//        }
    }
}

// MARK: - DataBindProtocol

extension StepTwoKoreanDiaryViewController: DataBindProtocol {
    func dataBind(topicID: Int?, inputText: String) {
        self.topicID = topicID
        hintTextView.text = inputText
        
        print(topicID, inputText, "🥳")
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewController {
    func postPapagoApi(diaryText: String) {
        PapagoAPI.shared.postDiary(param: diaryText) { response in
            guard let response = response else { return }
            self.hintText = self.hintTextView.text
            self.hintTextView.text.removeAll()
            self.hintTextView.text = response.message.result.translatedText
        }
    }
}
