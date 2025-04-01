//
//  CustomTextEditorStyle.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/25/25.
//

import SwiftUI

struct CustomTextEditorStyle: ViewModifier {
    let placeholder: String
    @Binding var text: String
    
    func body(content: Content) -> some View {
            content
                .padding(15)
                .background(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .lineSpacing(10)
                            .padding(20)
                            .padding(.top, 2)
                            .font(Font.custom("Pretendard", size: 16)).fontWeight(.regular)
                            .foregroundColor(Color(UIColor.gray400))
                    }
                }
                .textInputAutocapitalization(.none) // 첫 시작 대문자 막기
                .scrollContentBackground(.hidden)
                .autocorrectionDisabled()
                .background(Color(UIColor.gray100))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .font(Font.custom("Pretendard", size: 16)).fontWeight(.regular)
    }
}

extension TextEditor {
    func customStyleEditor(placeholder: String, userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput))
    }
}
