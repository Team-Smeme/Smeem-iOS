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
    case failProjVersion
}

enum AppId: Int {
    case identifire = 6450711685
}

struct System {
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    /// 앱 스토어 최신 정보 확인
    func latestVersion() async throws -> String? {
        print(AppId.identifire)
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(AppId.identifire.rawValue)&country=kr") else {
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
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/\(AppId.identifire.rawValue)") else { return }
        
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
