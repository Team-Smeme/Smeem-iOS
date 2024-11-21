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
    
    @State private var selectedIndex = 0
    let options = ["코칭 OFF", "코칭 ON"]
    
    var body: some View {
        HStack() {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/,
                   label: {
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
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/,
                   label: {
                Text("닫기")
                    .tint(.black)
            })
            .padding(.trailing, 18)
        }
        .frame(height: 66)
    }
}

#Preview {
    SwiftUINavigationView(navigationbarType: .diaryDetails)
}
