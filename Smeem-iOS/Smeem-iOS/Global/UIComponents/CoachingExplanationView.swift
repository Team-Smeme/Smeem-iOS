//
//  CoachingExplanationView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/16/24.
//

import SwiftUI

struct CoachingExplanationView: View {
    var body: some View {
        HStack() {
            
            ZStack(alignment: .leading) {
                GeometryReader { geomerty in
                    Rectangle()
                        .fill(Color(UIColor.gray100))
                        .frame(height: geomerty.size.height)
                        .cornerRadius(3)
                }
                
                Text("현재완료 시제인 have went는 과거 시제인 went로 바꾸는 것이 맞습니다. yesterday와 함께 사용할 때는 단순 과거 시제를 사용해야 합니다.")
                    .font(Font.custom("Pretendard", size: 14).weight(.regular))
                    .foregroundStyle(.black)
                    .padding(12)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 18)
            .padding(.trailing, 18)
        }
    }
}

#Preview {
    CoachingExplanationView()
}
