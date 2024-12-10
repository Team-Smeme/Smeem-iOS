//
//  CoachingComparisonView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/1/24.
//

import SwiftUI

import SwiftUI

struct CoachingComparisonView: View {
    @Binding var coachingResponse: CoachingResponse
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    
                    GeometryReader { geomerty in
                        Rectangle()
                            .frame(height: geomerty.size.height)
                            .foregroundStyle(Color(UIColor.black))
                    }
                    .frame(width: 2)
                    
                    Text("나의 일기")
                        .font(Font.custom("Pretendard", size: 16).weight(.medium))
                        .foregroundColor(Color(UIColor.black))
                    
                    Spacer()
                }
                
                Text(coachingResponse.originalSentence)
                    .font(Font.custom("Pretendard", size: 14)).fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.leading, 18)
            .padding(.trailing, 18)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    GeometryReader { geomerty in
                        Rectangle()
                            .frame(height: geomerty.size.height)
                            .foregroundStyle(Color(UIColor.point))
                    }
                    .frame(width: 2)
                    
                    Text("고친 문장")
                        .font(Font.custom("Pretendard", size: 16).weight(.medium))
                        .foregroundColor(Color(UIColor.point))
                    
                    Spacer()
                }
                
                Text(coachingResponse.correctedSentence)
                    .font(Font.custom("Pretendard", size: 14)).fontWeight(.medium)
                    .foregroundColor(Color(UIColor.point))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.leading, 18)
            .padding(.trailing, 18)
        }
    }
}
