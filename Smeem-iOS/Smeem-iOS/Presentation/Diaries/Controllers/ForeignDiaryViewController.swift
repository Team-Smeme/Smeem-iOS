//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - ForeignDiaryViewController

final class ForeignDiaryViewController: DiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNagivationBarDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
    }
}

// MARK: - Extensions

extension ForeignDiaryViewController {
    static func createWithForeignDiaryiew() -> ForeignDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        let viewModel = DiaryViewModel()
        return ForeignDiaryViewController(rootView: foreignDiaryView, viewModel: viewModel)
    }
    
    private func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
}

// MARK: - NavigationBarActionDelegate

extension ForeignDiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        rootView?.removeToolTip()
        presentingViewController?.dismiss(animated: true)
    }
    
    func didTapRightButton() {
        if rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
            viewModel?.inputText.value = rootView?.inputTextView.text ?? ""
            rootView?.inputTextView.resignFirstResponder()
            viewModel?.postDiaryAPI { postDiaryResponse in
                self.handlePostDiaryResponse(postDiaryResponse)
            }
        } else {
            viewModel?.showRegExToast()
        }
    }
}
