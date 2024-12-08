//
//  CoachingContentView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

//import SwiftUI
//
//struct CoachingContentView: View {
//    @Binding var currentIndex: Int
//    @Binding var coachingResponse: CoachingsResponse
//    
//    var body: some View {
//        VStack(spacing: screenHeight * (20 / screenHeight)) {
//            Rectangle()
//                .frame(height: screenHeight * (8 / screenHeight))
//                .foregroundStyle(Color(UIColor.gray100))
//            
//            TabView(selection: $currentIndex) {
//                ForEach(coachingResponse.corrections.indices, id: \.self) { item in
//                    ScrollView {
//                        VStack(spacing: screenWidth * (8 / screenWidth)) {
//                            CoachingComparisonView(coachingResponse: $coachingResponse.corrections[item])
//                            
//                            CoachingExplanationView(coachingResponse: $coachingResponse.corrections[item])
//                        }
//                    }
//                }
//            }
//            .frame(width: screenWidth, height: screenHeight * (286 / screenHeight), alignment: .top)
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .padding(.horizontal, screenWidth * (16 / screenWidth))
//            
//            PageControl(currentPage: $currentIndex,
//                        coachingResponse: $coachingResponse)
//        }
//    }
//}
//
//#Preview {
//    @State var defaultIndex: Int = 0
//    @State var coachingResponse = CoachingsResponse.empty
//    CoachingContentView(currentIndex: $defaultIndex, coachingResponse: $coachingResponse)
//}
