//
//  System.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/19.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

struct System {
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    /// 앱 스토어 최신 정보 확인
    func latestVersion() async throws -> String? {
        let appleID = 6450711685
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)&country=kr") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

            guard let results = json?["results"] as? [[String: Any]], let appStoreVersion = results[0]["version"] as? String else {
                throw NetworkError.invalidResponse
            }

            return appStoreVersion
        } catch {
            throw NetworkError.requestFailed
        }
    }
    
    /// 앱 스토어로 이동
    func openAppStore() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/6450711685") else { return }
        
//        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
        }
    }
}
