//
//  SwiftUINavigationView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/18.
//

import SwiftUI

enum NavigationbarType {
    case coachingCompleted
    case diaryDetails
    case hasEdited
}

struct SwiftUINavigationView: View {
    let navigationbarType: NavigationbarType
    let options = ["코칭 OFF", "코칭 ON"]
    
    @State private var showFloatingView = false
    @Binding var selectedIndex: Int
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            // 뒤로가기 버튼
            if navigationbarType == .diaryDetails {
                Button(action: {
                    dismiss() // 화면 pop
                }, label: {
                    Image("icnBack")
                        .imageScale(.large)
                })
                .padding(.leading, 12.scaledByWidth())
            } else {
                Spacer().frame(width: 30.scaledByWidth())
            }
            
            // 중앙 콘텐츠 (CustomSegmentedControl)
            if navigationbarType == .diaryDetails {
                CustomSegmentedControl(selectedIndex: $selectedIndex, options: options)
                    .frame(height: 32.scaledByHeight())
                    .padding(.leading, 65.scaledByWidth())
                    .padding(.trailing, 59.scaledByWidth())
            }
            
            Spacer()
            
            // 오른쪽 버튼
            if navigationbarType == .diaryDetails {
                Button(action: {
                    showFloatingView = true
                }, label: {
                    Image("icnMore")
                })
                .padding(.trailing, 18.scaledByWidth())
                .fullScreenCover(isPresented: $showFloatingView) {
                    FloatingButtonsSwiftUIView()
                }
            } else {
                Button(action: {
                    // 다른 버튼 액션
                }, label: {
                    Text("닫기")
                        .tint(.black)
                })
                .padding(.trailing, 18.scaledByWidth())
            }
        }
        .frame(height: 54.scaledByHeight())
    }
}

#Preview {
    @State var defaultIndex = 0
    
    NavigationView {
        SwiftUINavigationView(navigationbarType: .diaryDetails, selectedIndex: $defaultIndex)
    }
}
