//
//  CoachingContentView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

import SwiftUI

struct CoachingContentView: View {
    @Binding var currentIndex: Int
    @Binding var detailDiaryResponse: DetailDiaryResponse
    @Binding var corrections: [CoachingResponse]

    var body: some View {
        VStack(spacing: 20.scaledByHeight()) {
            Rectangle()
                .frame(height: 8.scaledByHeight())
                .foregroundStyle(Color(UIColor.gray100))
            
            TabView(selection: $currentIndex) {
                ForEach(corrections.indices, id: \.self) { item in
                    ScrollView {
                        VStack(spacing: 8.scaledByHeight()) {
                            CoachingComparisonView(coachingResponse: $corrections[item])
                            CoachingExplanationView(coachingResponse: $corrections[item])
                        }
                    }
                }
            }
            .frame(width: screenWidth, height: screenHeight * (286 / screenHeight), alignment: .top)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, 16.scaledByWidth())
            
            PageControl(currentPage: $currentIndex, coachingResponse: $corrections)
        }
    }
}

//#Preview {
//    @State var defaultIndex: Int = 0
//    @State var coachingsResponse = CoachingsResponse.empty
//    @State var coachingResponse = CoachingsResponse.empty.corrections
//    CoachingContentView(currentIndex: $defaultIndex, coachingsResponse: $coachingsResponse, coachingResponse: $coachingResponse)
//}
