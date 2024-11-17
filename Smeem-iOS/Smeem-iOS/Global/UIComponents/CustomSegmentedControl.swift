//
//  CustomSegmentedControl.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/22.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    let options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                SegmentButton(
                    title: options[index],
                    isSelected: selectedIndex == index,
                    action: { selectedIndex = index }
                )
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 8)
                .padding(.horizontal, 11)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .font(Font(UIFont.c5))
        }
    }
    
    private var backgroundColor: Color {
        isSelected ? (isCoachingOn ? Color(UIColor.point) : Color(UIColor.gray200)) : Color(UIColor.gray100)
    }
    
    private var foregroundColor: Color {
        isSelected ? .white : Color(UIColor.gray500)
    }
    
    private var isCoachingOn: Bool {
        title == "코칭 ON"
    }
}

struct PreviewWrapper: View {
    @State private var selectedIndex = 0
    let options = ["코칭 OFF", "코칭 ON"]
    
    var body: some View {
        CustomSegmentedControl(selectedIndex: $selectedIndex, options: options)
            .frame(height: 40)
            .padding(117)
    }
}

@available(iOS 17.0, *)
#Preview {
    PreviewWrapper()
}

