//
//  KeyboardResponder.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/26/25.
//

import Combine
import SwiftUI

struct KeyboardAdaptive: ViewModifier {
  @State private var keyboardHeight: CGFloat = 0
  
  private let keyboardWillShow = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    .compactMap { notification in
      notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
    .map { rect in
      rect.height
    }
  
  private let keyboardWillHide = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillHideNotification)
    .map { _ in CGFloat(0) }
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, keyboardHeight)
      .onReceive(
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
      ) { height in
          withAnimation(.easeInOut(duration: 0.3)) {
              if height == 0 {
                  self.keyboardHeight = 0
              } else {
                  self.keyboardHeight = height-40
              }
        }
      }
  }
}

extension View {
  func keyboardAdaptive() -> some View {
    ModifiedContent(content: self, modifier: KeyboardAdaptive())
  }
}
