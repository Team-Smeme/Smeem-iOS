//
//  SplashViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/07.
//

import UIKit
import Combine

final class SplashViewController: BaseViewController {
    
    private let viewModel = SplashViewModel()
    
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
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.presentUpdatePopup()
            }
            .store(in: &cancelBag)
        
        output.smeemStartResult
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.changeRootViewController(SmeemStartViewController())
            }
            .store(in: &cancelBag)
        
        output.homeStartResult
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.changeRootViewController(HomeViewController())
            }
            .store(in: &cancelBag)
        
        output.errorResult
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
        
        output.loadingViewResult
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Method
    
    private func presentUpdatePopup() {
        let updateAlert = UIAlertController(title: "업데이트 알림", message: "보다 나아진 스밈의 최신 버전을 준비했어요! 새로운 버전으로 업데이트 후 이용해주세요.", preferredStyle: UIAlertController.Style.alert)
        
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
