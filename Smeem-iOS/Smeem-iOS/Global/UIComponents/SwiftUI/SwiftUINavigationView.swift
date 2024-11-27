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
}

struct SwiftUINavigationView: View {
    let navigationbarType: NavigationbarType
    @State private var showFloatingView = false
    @Binding var selectedIndex: Int
    
    let options = ["코칭 OFF", "코칭 ON"]
    
    var body: some View {
        HStack {
            // 뒤로가기 버튼
            if navigationbarType == .diaryDetails {
                Button(action: {
                    // 뒤로가기 액션
                }, label: {
                    Image("icnBack")
                        .imageScale(.large)
                })
                .padding(.leading, 10 / screenWidth)
            } else {
                Spacer().frame(width: 30 / screenWidth)
            }
            
            // 중앙 콘텐츠 (CustomSegmentedControl)
            if navigationbarType == .diaryDetails {
                CustomSegmentedControl(selectedIndex: $selectedIndex, options: options)
                    .frame(height: 32 / screenHeight)
                    .padding(65)
            }
            
            Spacer()
            
            // 오른쪽 버튼
            if navigationbarType == .diaryDetails {
                Button(action: {
                    showFloatingView = true
                }, label: {
                    Image("icnMore")
                })
                .padding(.trailing, 18 / screenWidth)
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
                .padding(.trailing, 18 / screenWidth)
            }
        }
        .frame(height: screenHeight * (66 / screenHeight))
    }
}

#Preview {
    @State var defaultIndex = 0
    
    SwiftUINavigationView(navigationbarType: .diaryDetails, selectedIndex: $defaultIndex)
}
