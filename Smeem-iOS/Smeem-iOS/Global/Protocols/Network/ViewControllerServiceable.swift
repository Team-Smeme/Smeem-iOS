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
    func handlerError(version: String, _ error: Error)
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
    
    func handlerError(version: String = ConfigConstant.version, _ error: NetworkError) {
        if version == "Release" {
            
            switch error {
            case .systemError:
                showToast(toastType: .networkErrorToast(message: "죄송합니다, 시스템 오류가 발생했어요 :("))
            case .loadDataError:
                showToast(toastType: .networkErrorToast(message: "데이터를 불러올 수 없어요 :("))
            default: break
            }
        } else {
            switch error {
            case .systemError:
                showToast(toastType: .smeemErrorToast(text: "client error"))
            case .loadDataError:
                showToast(toastType: .smeemErrorToast(text: "server error"))
            case .jsonDecodingError:
                showToast(toastType: .smeemErrorToast(text: "json decoding error"))
            case .jsonEncodingError:
                showToast(toastType: .smeemErrorToast(text: "json encoding error"))
            case .typeCastingError:
                showToast(toastType: .smeemErrorToast(text: "type casting error"))
            case .unAuthorizedError:
                showToast(toastType: .smeemErrorToast(text: "토큰 만료"))
            case .unknownError(let message):
                showToast(toastType: .smeemErrorToast(text: "알 수 없는 에러 : \(message)"))
            case .urlEncodingError:
                showToast(toastType: .smeemErrorToast(text: "url encoding error"))
            default: break
            }
        }
    }
}
