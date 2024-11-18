//
//  CoachingCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/16/24.
//

import SwiftUI

struct CoachingCell: View {
    
    var body: some View {
        
        CoachingCompletedView()
        
        VStack(spacing: 20) {
            Rectangle()
                .frame(height: 8)
                .foregroundStyle(Color(UIColor.gray100))
            
            TabView {
                ForEach(1...5, id: \.self) { item in
                    VStack(spacing: 8) {
                        CoachingComparisonView()
                        
                        CoachingExplanationView()
                    }
                    .frame(width: screenWidth, height: screenHeight * (326/screenHeight), alignment: .top)
                }
            }
            .onAppear { setIndicator() }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
    
    private func setIndicator() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.primary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.gray)
    }
}

#Preview {
    CoachingCell()
}
