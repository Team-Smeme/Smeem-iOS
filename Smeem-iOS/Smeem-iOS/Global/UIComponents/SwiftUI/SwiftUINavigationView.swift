//
//  SwiftUINavigationView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/18.
//

import Combine
import SwiftUI

enum NavigationbarType {
    case coachingCompleted
    case diaryDetails
    case unCoached
}

final class NavigationViewModel: ObservableObject {
    let leftButtonTapped = PassthroughSubject<Void, Never>()
    let rightButtonTapped = PassthroughSubject<Void, Never>()
}

struct SwiftUINavigationView: View {

    @ObservedObject var viewModel: NavigationViewModel
    
    @State private var showFloatingView = false
    @Binding var selectedIndex: Int
    
    let navigationbarType: NavigationbarType
    let options = ["코칭 OFF", "코칭 ON"]
    
    var body: some View {
        HStack {
            // 뒤로가기 버튼
            if navigationbarType == .diaryDetails || navigationbarType == .unCoached {
                Button(action: {
                    viewModel.leftButtonTapped.send()
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
            if navigationbarType == .diaryDetails || navigationbarType == .unCoached {
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
                    viewModel.rightButtonTapped.send()
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
        SwiftUINavigationView(viewModel: NavigationViewModel(), selectedIndex: $defaultIndex, navigationbarType: .unCoached)
    }
}
