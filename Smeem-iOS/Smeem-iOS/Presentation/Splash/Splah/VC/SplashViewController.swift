//
//  SplashViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/07.
//

import UIKit
import Combine

final class SplashViewController: BaseViewController {
    
    private let viewModel = SplashViewModel(provider: SplashService())
    
    // MARK: Publisher
    
    private let checkUpdatePopup = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: UI Properties
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.splashImage
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUpdatePopup.send(())
    }
    
    private func bind() {
        let input = SplashViewModel.Input(checkUpdatePopup: checkUpdatePopup)
        let output = viewModel.transform(input: input)
        
        output.updatePopupResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.presentUpdatePopup(model: model)
            }
            .store(in: &cancelBag)
        
        output.smeemStartResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let smeemStartVC = SmeemStartViewController()
                self?.changeRootViewController(smeemStartVC)
            }
            .store(in: &cancelBag)
        
        output.homeStartResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.changeRootViewController(HomeViewController())
            }
            .store(in: &cancelBag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Method
    
    private func presentUpdatePopup(model: UpdateTextModel) {
        let updateAlert = UIAlertController(title: model.title,
                                            message: model.content,
                                            preferredStyle: UIAlertController.Style.alert)
        
        let update = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default) { (_) in
            System().openAppStore()
            
            /// 0.5 delay 준 버전
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                let restartAlert = UIAlertController(title: "업데이트 완료", message: "앱을 재실행합니다.", preferredStyle: UIAlertController.Style.alert)
                let restart = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in

                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }

                restartAlert.addAction(restart)
                self.present(restartAlert, animated: true)
            }
        }
        
        updateAlert.addAction(update)
        self.present(updateAlert, animated: true)
    }
    
    private func setLayout() {
        view.addSubview(splashImageView)
        
        splashImageView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
        }
    }
}
