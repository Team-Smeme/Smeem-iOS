//
//  ToastView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/19/24.
//

import SwiftUI

struct SmeemErrorToastView: View {
    @Binding var type: SmeemError?
    @State private var opacity: Double = 0.0
    
    var body: some View {
        if let error = type {
            ZStack {
                Spacer()
                VStack {
                    HStack(spacing: 14) {
                        Image("icnToastError")
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(error.displayText)
                                .font(Font.custom("Pretendard", size: 14).weight(.bold))
                                .foregroundColor(.white)
                            
                            Text("재접속하거나 나중에 다시 시도해 주세요.")
                                .font(Font.custom("Pretendard", size: 12))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: screenWidth-36, height: 70)
                    .background(Color(UIColor.toastBackground))
                    .cornerRadius(6)
                    .padding(.bottom, 20)
                    .opacity(opacity)
                    .transition(.opacity)
                    .onAppear {
                        
                        withAnimation(.easeIn(duration: 0.6)) {
                            opacity = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                opacity = 0.0
                                type = nil
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SmemeToastView: View {
    @Binding var type: SmeemToast?
    @State private var opacity: Double = 0.0
    
    var body: some View {
        if let toast = type {
            ZStack {
                Spacer()
                    HStack {
                        Text(toast.displayText)
                            .font(Font.custom("Pretendard", size: 14).weight(.medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 17)
                            .padding(.leading, 18)
                        Spacer()
                }
                .frame(width: screenWidth-36, height: 50)
                .background(Color(UIColor.toastBackground))
                .cornerRadius(6)
                .padding(.bottom, 20)
                .opacity(opacity)
                .transition(.opacity)
                .onAppear {
                    
                    withAnimation(.easeIn(duration: 0.6)) {
                        opacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeOut(duration: 0.6)) {
                            opacity = 0.0
                            type = nil
                        }
                    }
                }
            }
        }
    }
}
