//
//  EditDiaryViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/02.
//

import UIKit

import SnapKit

final class EditDiaryViewController: BaseViewController {
    
    // MARK: - Property

    var diaryID = Int()
    var randomContent = String()
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.smeemBlack, for: .normal)
        button.titleLabel?.font = .b4
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let editTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.textColor = .smeemBlack
        label.font = .s2
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.point, for: .normal)
        button.titleLabel?.font = .b1
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.text = "dafd???"
        textView.configureDiaryTextView(topInset: 20)
        textView.configureAttributedText()
        textView.delegate = self
        return textView
    }()
    
    lazy var randomSubjectView = DiaryDetailRandomSubjectView()
    private let loadingView = LoadingView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setRandomSubjectLayout()
        showKeyboard(textView: diaryTextView)
        keyboardAddObserver()
    }
    
    deinit {
        keyboardRemoveObserver()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonDidTap() {
        self.showLodingView(loadingView: self.loadingView)
        patchDiaryAPI()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            diaryTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        diaryTextView.contentInset = .zero
    }
    
    // MARK: - Custom Method
    
    // MARK: - Layout
    
    private func setBackrgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(naviView)
        naviView.addSubviews(backButton, editTitleLabel, completeButton)
        
        naviView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18 - 5)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(28 + 10)
            $0.height.equalTo(42)
        }
        
        editTitleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18 - 5)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(28 + 10)
            $0.height.equalTo(42)
        }
    }
    
    private func setRandomSubjectLayout() {
        view.addSubviews(diaryTextView, randomSubjectView)
        
        if randomContent == "" {

            randomSubjectView.isHidden = true
            diaryTextView.snp.makeConstraints {
                $0.top.equalTo(naviView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        } else {
            randomSubjectView.snp.makeConstraints {
                $0.top.equalTo(naviView.snp.bottom)
                $0.leading.equalToSuperview()
            }
            
            diaryTextView.snp.makeConstraints {
                $0.top.equalTo(randomSubjectView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    private func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension EditDiaryViewController {
    func patchDiaryAPI() {
        PostDiaryAPI.shared.patchDiary(param: PatchDiaryRequest(content: diaryTextView.text), diaryID: diaryID) { response in
            DispatchQueue.main.async {
                self.hideLodingView(loadingView: self.loadingView)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EditDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        completeButton.isEnabled = englishValidation(with: self.diaryTextView.text, in: self)
        completeButton.setTitleColor(completeButton.isEnabled ? .point : .gray400, for: .normal)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let cursorPosition = textView.selectedTextRange?.end
        if let cursorPosition = cursorPosition {
            let caretPositionRect = textView.caretRect(for: cursorPosition)
            textView.scrollRectToVisible(caretPositionRect, animated: true)
        }
    }
    
    func englishValidation(with text: String, in viewController: EditDiaryViewController) -> Bool {
        return viewController.diaryTextView.text.getArrayAfterRegex(regex: "[a-zA-z]").count > 0
    }
}
