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
    @Binding var selectedIndex: Int
    
    let options = ["코칭 OFF", "코칭 ON"]
    
    var body: some View {
        HStack {
            Button(action: {
                // 뒤로가기 액션
            }, label: {
                Image("icnBack")
                    .imageScale(.large)
            })
            .padding(.leading, 10)
            
            if navigationbarType == .diaryDetails {
                CustomSegmentedControl(selectedIndex: $selectedIndex, options: options)
                    .frame(height: 32)
                    .padding(65)
            }
            
            Spacer()
            
            Button(action: {
                // 닫기 버튼 액션
            }, label: {
                Text("닫기")
                    .tint(.black)
            })
            .padding(.trailing, 18)
        }
        .frame(height: screenHeight * (66 / screenHeight))
    }
}

#Preview {
    @State var defaultIndex = 0
    
    SwiftUINavigationView(navigationbarType: .diaryDetails, selectedIndex: $defaultIndex)
}
