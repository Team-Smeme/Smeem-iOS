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

struct SmemeEmptyView: View {
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
        }
        .animation(.easeInOut(duration: 0.5), value: true) // 0.5초 뒤에 서서히 사라짐
    }
}
