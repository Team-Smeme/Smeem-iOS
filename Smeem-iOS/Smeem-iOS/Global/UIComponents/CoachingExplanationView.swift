//
//  CoachingExplanationView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/16/24.
//

import SwiftUI

struct CoachingExplanationView: View {
    @Binding var coachingResponse: CoachingResponse
    
    var body: some View {
        HStack() {
            
            ZStack(alignment: .leading) {
                GeometryReader { geomerty in
                    Rectangle()
                        .fill(Color(UIColor.gray100))
                        .frame(height: geomerty.size.height)
                        .cornerRadius(3)
                }
                
                Text(coachingResponse.reason)
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

//#Preview {
//    CoachingExplanationView()
//}
