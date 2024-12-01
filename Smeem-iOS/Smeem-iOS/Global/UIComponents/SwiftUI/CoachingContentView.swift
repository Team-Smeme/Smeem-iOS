//
//  CoachingContentView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

import SwiftUI

struct CoachingContentView: View {
    @Binding var currentIndex: Int
    @Binding var coachingResponse: CoachingsResponse
    
    var body: some View {
        VStack(spacing: 20.scaledByHeight()) {
            Rectangle()
                .frame(height: 8.scaledByHeight())
                .foregroundStyle(Color(UIColor.gray100))
            
            TabView(selection: $currentIndex) {
                ForEach(coachingResponse.corrections.indices, id: \.self) { item in
                    ScrollView {
                        VStack(spacing: 8.scaledByHeight()) {
                            CoachingComparisonView(coachingResponse: $coachingResponse.corrections[item])
                            
                            CoachingExplanationView(coachingResponse: $coachingResponse.corrections[item])
                        }
                    }
                }
            }
            .frame(width: screenWidth, height: screenHeight * (286 / screenHeight), alignment: .top)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, 16.scaledByWidth())
            
            PageControl(currentPage: $currentIndex,
                        coachingResponse: $coachingResponse)
        }
    }
}

#Preview {
    @State var defaultIndex: Int = 0
    @State var coachingResponse = CoachingsResponse.empty
    CoachingContentView(currentIndex: $defaultIndex, coachingResponse: $coachingResponse)
}
