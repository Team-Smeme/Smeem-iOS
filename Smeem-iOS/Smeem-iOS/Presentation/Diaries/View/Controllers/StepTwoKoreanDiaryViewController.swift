//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit
import Combine

// MARK: - StepTwoKoreanDiaryViewController

final class StepTwoKoreanDiaryViewController: DiaryViewController<StepTwoKoreanDiaryViewModel> {
    
    // MARK: - Subjects
    
    private (set) var hintTextSubject = PassthroughSubject<String, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let viewFactory = DiaryViewFactory()
    private var diaryText = ""
    
    // MARK: - Life Cycle
    
    init(viewModel: StepTwoKoreanDiaryViewModel, text: String) {
        super.init(rootView: viewFactory.createStepTwoKoreanDiaryView(), viewModel: viewModel)
        diaryText = text
        rootView.configuration.layoutConfig?.updateHintViewText(with: diaryText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        hintTextSubject.send(rootView.configuration.layoutConfig?.getHintViewText() ?? "")
    }
}

extension StepTwoKoreanDiaryViewController {
    private func bind() {
        let input = StepTwoKoreanDiaryViewModel.Input(rightButtonTapped: rootView.navigationView.rightButtonTapped,
                                                      hintButtonTapped: rootView.bottomView.hintButtonTapped,
                                                      hintTextsubject: hintTextSubject)
        
        let output = viewModel.transform(input: input)
        
        rootView.navigationView.leftButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.removeToolTip()
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        output.rightButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.rootView.inputTextView.resignFirstResponder()
                
                let homeVC = HomeViewController()
                let rootVC = UINavigationController(rootViewController: homeVC)
                homeVC.handlePostDiaryAPI(with: response)
                homeVC.changeRootViewControllerAndPresent(rootVC)
            }
            .store(in: &cancelBag)
        
        output.hintButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHintShowed in
                self?.rootView.bottomView.updateHintButtonImage(isHintShowed)
                if isHintShowed == false {
                    self?.rootView.configuration.layoutConfig?.updateHintViewText(with: self?.diaryText)
                }
            }
            .store(in: &cancelBag)
        
        output.postHintResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.rootView.configuration.layoutConfig?.updateHintViewText(with: text)
            }
            .store(in: &cancelBag)
        
        output.toastValidationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] height in
                self?.showToast(toastType: .smeemToast(bodyType: .regEx), hasKeyboard: true, height: height)
            }
            .store(in: &cancelBag)
    }
}
