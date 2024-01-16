//
//  SmeemLoadingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/06.
//

import UIKit

final class SmeemLoadingView: UIActivityIndicatorView {
    static func showLoading() {
        DispatchQueue.main.async {
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScenes?.windows.last else { return }
            let loadingIndicatorView: UIActivityIndicatorView
            
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .medium)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.backgroundColor = .popupBackground
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScenes?.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
