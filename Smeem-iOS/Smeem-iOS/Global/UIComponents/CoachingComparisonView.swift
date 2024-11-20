//
//  CoachingComparisonView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/1/24.
//

import SwiftUI

struct CoachingComparisonView: View {
    @Binding var coachingResponse: CoachingResponse
    @State private var textHeight: CGFloat = 0 // Text의 높이를 저장할 변수
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Rectangle()
                        .frame(width: 2, height: textHeight)
                        .foregroundStyle(Color(UIColor.black))
                    
                    Text("나의 일기")
                        .font(Font.custom("Pretendard", size: 16).weight(.medium))
                        .foregroundColor(Color(UIColor.black))
                        .background(GeometryReader { geometry in
                            Color.clear
                                .preference(key: TextHeightPreferenceKey.self, value: geometry.size.height)
                        })
                }
                .onPreferenceChange(TextHeightPreferenceKey.self) { value in
                    textHeight = value
                }
                
                Text(coachingResponse.original_sentence)
                    .font(Font.custom("Pretendard", size: 14)).fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.leading, 18)
            .padding(.trailing, 18)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Rectangle()
                        .frame(width: 2, height: textHeight)
                        .foregroundStyle(Color(UIColor.point))
                    
                    Text("고친 문장")
                        .font(Font.custom("Pretendard", size: 16).weight(.medium))
                        .foregroundColor(Color(UIColor.point))
                }
                
                Text(coachingResponse.corrected_sentence)
                    .font(Font.custom("Pretendard", size: 14)).fontWeight(.medium)
                    .foregroundColor(Color(UIColor.point))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.leading, 18)
            .padding(.trailing, 18)
        }
    }
}

struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//#Preview {
//    CoachingComparisonView()
//}
