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
                    isFirstButton: index == 0,
                    isLastButton: index == options.count - 1,
                    action: { selectedIndex = index }
                )
            }
        }
        .cornerRadius(6)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .font(Font(UIFont.b3))
                .overlay(
                    Group {
                        if isSelected && isFirstButton {
                            CustomStrokeShape(
                                includeLeadingCorners: isFirstButton,
                                includeTrailingCorners: isLastButton
                            )
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
        .frame(width: 70, height: 32)
    }
    
    private var backgroundColor: Color {
        // 왼쪽 버튼 논리
        if isFirstButton {
            return isSelected ? Color(UIColor.gray100) : Color(UIColor.white)
        }
        // 오른쪽 버튼 논리
        return isSelected ? Color(UIColor.point) : Color(UIColor.white)
    }
    
    private var foregroundColor: Color {
        isSelected ? isFirstButton ? Color(UIColor.gray500): Color(UIColor.smeemWhite) : Color(UIColor.gray500)
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
