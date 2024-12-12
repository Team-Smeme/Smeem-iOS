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
                    isSelected: isCoachingOn(index),
                    isFirstButton: index == 0,
                    isLastButton: index == options.count - 1,
                    action: { selectedIndex = index }
                )
            }
        }
//        .background(Color.gray.opacity(0.2))
        .cornerRadius(6)
    }
    
    private func isCoachingOn(_ index: Int) -> Bool {
        return options[index] == "코칭 ON" && selectedIndex == index
    }
}

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let isFirstButton: Bool
    let isLastButton: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 8.scaledByHeight())
                .padding(.horizontal, 10.scaledByWidth())
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .font(Font(UIFont.c5))
//                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .overlay(
                    Group {
                        if isSelected && isFirstButton {
                            CustomStrokeShape(includeLeadingCorners: false)
                                .stroke(Color(UIColor.gray500), lineWidth: 1)
                        } else if !isSelected {
                            CustomStrokeShape(
                                includeLeadingCorners: isFirstButton,
                                includeTrailingCorners: isLastButton
                            )
                            .stroke(Color(UIColor.gray500), lineWidth: 1)
                        }
                    }
                )
        }
    }
    
    private var backgroundColor: Color {
        isSelected ? Color(UIColor.point) : isFirstButton ? Color(UIColor.gray100) : Color(UIColor.white)
    }
    
    private var foregroundColor: Color {
        isSelected ? Color(UIColor.smeemWhite) : Color(UIColor.gray500)
    }
    
    private var isCoachingOn: Bool {
        title == "코칭 ON"
    }
}

struct CustomStrokeShape: Shape {
    var radius: CGFloat = 6
    var includeLeadingCorners: Bool = true
    var includeTrailingCorners: Bool = true
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Move to the starting point (TopLeading)
        path.move(to: CGPoint(x: rect.minX + (includeLeadingCorners ? radius : 0), y: rect.minY))
        
        // TopLeading Corner
        if includeLeadingCorners {
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: .degrees(-90),
                endAngle: .degrees(180),
                clockwise: true
            )
        } else {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
        
        // BottomLeading Corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - (includeLeadingCorners ? radius : 0)))
        if includeLeadingCorners {
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(90),
                clockwise: true
            )
        } else {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        
        // BottomTrailing Corner
        path.addLine(to: CGPoint(x: rect.maxX - (includeTrailingCorners ? radius : 0), y: rect.maxY))
        if includeTrailingCorners {
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: .degrees(90),
                endAngle: .degrees(0),
                clockwise: true
            )
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        
        // TopTrailing Corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + (includeTrailingCorners ? radius : 0)))
        if includeTrailingCorners {
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: .degrees(0),
                endAngle: .degrees(-90),
                clockwise: true
            )
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        
        path.closeSubpath()
        return path
    }
}

@available(iOS 17.0, *)
#Preview {
    @State var selectedIndex = 1
    let options = ["코칭 OFF", "코칭 ON"]
    
    CustomSegmentedControl(selectedIndex: $selectedIndex, options: options)
        .frame(height: 32.scaledByHeight())
        .padding(117.scaledByWidth())
}
