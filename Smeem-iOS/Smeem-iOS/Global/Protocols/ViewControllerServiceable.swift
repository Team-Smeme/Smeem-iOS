//
//  ViewControllerServiceable.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/06.
//

import UIKit

/// 네트워크 요청을 하는 VC가 채택하는 프로토콜
protocol ViewControllerServiceable where Self: UIViewController {
    
    /// - Parameter error : 네트워크 통신 중 throw 된 에러 전달
    func showLoadingView()
    func hideLoadingView()
    func handlerError(_ error: NetworkError)
}

extension ViewControllerServiceable {
    
    func showLoadingView() {
        // 현재 로딩 애니메이션이 실행 중일 때
        if let loadingView = getLoadingView() {
            loadingView.stopAnimating()
            return
        }
        
        let loadingView = SmeemLoadingView()
        loadingView.startAnimating()
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func hideLoadingView() {
        getLoadingView()?.stopAnimating()
        getLoadingView()?.removeFromSuperview()
    }
    
    private func getLoadingView() -> SmeemLoadingView? {
        return view.subviews.compactMap { $0 as? SmeemLoadingView }.first
    }
    
    func handlerError(_ error: NetworkError) {
        switch error {
        case .urlEncodingError:
//            showToast(toastType: .errorToast(errorType: self.description))
            showToast(toastType: .errorToast(errorType: .urlEncodingError))
        case .jsonDecodingError:
            showToast(toastType: .errorToast(errorType: .jsonDecodingError))
        case .jsonEncodingError:
            showToast(toastType: .errorToast(errorType: .jsonEncodingError))
        case .clientError(message: _):
            showToast(toastType: .errorToast(errorType: .clinetError))
        case .serverError:
            showToast(toastType: .errorToast(errorType: .serverError))
        case .unAuthorizedError:
            showToast(toastType: .errorToast(errorType: .unAuthorizedError))
        }
    }
}
