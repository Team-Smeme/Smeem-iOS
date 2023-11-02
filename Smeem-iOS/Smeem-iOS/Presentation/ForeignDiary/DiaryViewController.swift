//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

class DiaryViewController: BaseViewController, NavigationBarActionDelegate {
    
    // MARK: - Properties
    
    private var rootView: DiaryView?
    private var viewModel: DiaryViewModel?

    private var delegateSetupStrategy: DelegateSetupStrategy = DefaultDelegateSeupStrategy()
    private weak var delegate: UITextViewDelegate?
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
        
        setNagivationBarDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showKeyboard(textView: diaryView.inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateSetupStrategy.setupDelegate(for: self)
        
//        diaryView?.leftButtonActionStategy = DismissLeftButtonActionStrategy(viewContoller: self)
//        setDelegate()
//        setupKeyboardHandler()
    }
    
    deinit {
//        keyboardInfo?.keyboardHandler = nil
    }
    
    func didTapLeftButton() { }
    func didTapRightButton() { }
}

// MARK: - Extensions

extension DiaryViewController {
    
    func setRootView() {
        view = rootView
    }
    
    func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
    
    func setDelegateSetupStrategy(_ strategy: DelegateSetupStrategy) {
        delegateSetupStrategy = strategy
    }
    
//    private func setupKeyboardHandler() {
//        self.keyboardHandler = KeyboardFollowingLayoutHandler(targetView: diaryView.inputTextView, bottomView: DiaryView.bottomView)
//    }
    
    // MARK: - @objc

//    @objc func dismissButtonDidTap() {
//        dismissButton?.removeFromSuperview()
//    }
//
//    @objc func randomSubjectToolTipDidTap() {
//        self.randomSubjectToolTip?.isHidden = true
//        UserDefaultsManager.randomSubjectToolTip = true
//    }
    
    // MARK: - Custom Methods
    
//    func showToastIfNeeded(toastType: ToastViewType) {
//        smeemToastView?.removeFromSuperview()
//        smeemToastView = SmeemToastView(type: toastType)
//
//        let onKeyboardOffset = convertByHeightRatio(73)
//        let offKeyboardOffset = convertByHeightRatio(107)
//
//        let offset = isKeyboardVisible ? onKeyboardOffset : offKeyboardOffset
//
//        smeemToastView?.show(in: view, offset: CGFloat(offset), keyboardHeight: keyboardHeight)
//        smeemToastView?.hide(after: 1)
//    }
    
//    private func setData() {
//        randomSubjectView.setData(contentText: topicContent)
//    }
//
//    private func setDelegate() {
//        randomSubjectView.delegate = self
//    }
    
//    private func setRandomTopicButtonToggle() {
//        randomTopicEnabled.toggle()
//    }

//    private func updateRandomTopicView() {
//        if randomTopicEnabled {
//            view.addSubview(randomSubjectView)
//            randomSubjectView.snp.makeConstraints {
//                $0.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
//                $0.leading.equalToSuperview()
//            }
//            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
//        } else {
//            randomSubjectView.removeFromSuperview()
//            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
//        }
//    }
//
//    private func updateInputTextViewConstraints() {
//        inputTextView.snp.remakeConstraints {
//            $0.top.equalTo(randomTopicEnabled ? randomSubjectView.snp.bottom : navigationView.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(bottomView.snp.top)
//        }
//    }
}

//MARK: - RandomSubjectViewDelegate

extension DiaryViewController: RandomSubjectViewDelegate {
    func refreshButtonTapped(completion: @escaping (String?) -> Void) {
//        randomSubjectWithAPI()
    }
}

// MARK: - Network

extension DiaryViewController {
//    func randomSubjectWithAPI() {
//        RandomSubjectAPI.shared.getRandomSubject { response in
//            guard let randomSubjectData = response?.data else { return }
//            self.topicID = randomSubjectData.topicId
//            self.topicContent = randomSubjectData.content
//            self.setData()
//        }
//    }
    
//    func postDiaryAPI() {
//        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: diaryView.inputTextView.text, topicId: topicID)) { response in
//            guard let postDiaryResponse = response?.data else { return }
//            self.diaryID = postDiaryResponse.diaryID
//
//            if !postDiaryResponse.badges.isEmpty {
//                self.badgePopupContent = postDiaryResponse.badges
//            } else {
//                self.badgePopupContent = []
//            }
//
//            DispatchQueue.main.async {
//                let homeVC = HomeViewController()
//                homeVC.toastMessageFlag = true
//                homeVC.badgePopupData = self.badgePopupContent
//                //                self.randomSubjectToolTip = nil
//                let rootVC = UINavigationController(rootViewController: homeVC)
//                self.changeRootViewControllerAndPresent(rootVC)
//            }
//        }
//    }
}


// MARK: - Tutorial

//extension DiaryViewController {
//    private func checkTutorial() {
//        if self is StepOneKoreanDiaryViewController {
//            let tutorialDiaryStepOne = UserDefaultsManager.tutorialDiaryStepOne
//
//            if !tutorialDiaryStepOne {
//                UserDefaultsManager.tutorialDiaryStepOne = true
//
//                view.addSubviews(tutorialImageView ?? UIImageView(), dismissButton ?? UIButton())
//
//                tutorialImageView?.snp.makeConstraints {
//                    $0.top.leading.trailing.bottom.equalToSuperview()
//                }
//                dismissButton?.snp.makeConstraints {
//                    $0.top.equalToSuperview().inset(convertByHeightRatio(204))
//                    $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
//                    $0.width.height.equalTo(convertByHeightRatio(45))
//                }
//            } else {
//                tutorialImageView = nil
//                dismissButton = nil
//            }
//        }
//    }
//}
