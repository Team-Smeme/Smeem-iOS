//
//  RandomTopicViewSwiftUI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 12/11/24.
//

import SwiftUI

struct RandomTopicViewSwiftUI: View {
    
    // MARK: - Properties
    
    var contentText: String?
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("Q.")
                    .font(Font(UIFont.b1))
                    .foregroundColor(Color(UIColor.point))
                    .padding(.leading, 18.scaledByWidth())
                
                Text(contentText ?? "")
                    .font(Font(UIFont.b4))
                    .foregroundColor(Color(UIColor.smeemBlack))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 30.scaledByWidth())
            }
            .padding(.top, 20.scaledByHeight())
            .padding(.bottom, 20.scaledByHeight())
            .background(Color(UIColor.gray100))
        }
        .frame(height: contentText?.count ?? 0 > 20 ? 84.scaledByHeight() : 62.scaledByHeight())
    }
}

#Preview {
    var text: String = "랜덤주제 한줄일 경우 "
    RandomTopicViewSwiftUI(contentText: text)
}
