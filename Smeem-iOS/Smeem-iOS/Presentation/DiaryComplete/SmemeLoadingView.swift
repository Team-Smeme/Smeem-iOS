//
//  SmemeLoadingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/26/24.
//

import SwiftUI

struct SmemeLoadingView: View {
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
        .background(Color.white.opacity(0.1)) // 반투명 배경
        .allowsHitTesting(true) // 로딩 중 터치 차단
    }
}
