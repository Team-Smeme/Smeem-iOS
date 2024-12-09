//
//  FloatingButtonsSwiftUIView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/26/24.
//

import Combine
import SwiftUI

final class FloatingButtonsViewModel: ObservableObject {
    private(set) var editButtonTapped = PassthroughSubject<Void, Never>()
    private(set) var deleteButtonTapped = PassthroughSubject<Void, Never>()
}

struct FloatingButtonsSwiftUIView: View {
    @ObservedObject var viewModel: FloatingButtonsViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("수정하기")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.blue)
                    }
                    .alert("수정시 모든 코칭 내용이 사라집니다. 그래도 수정하시겠습니까?",
                           isPresented: $showAlert) {
                        Button("취소") {
                            dismiss()
                        }
                        Button("확인") {
                            viewModel.editButtonTapped.send()
                        }
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color.gray.opacity(0.5))
                    
                    Button(action: {
                        viewModel.deleteButtonTapped.send()
                    }) {
                        Text("삭제하기")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.red)
                    }
                }
                .background(Color.white)
                .cornerRadius(14)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .foregroundColor(.blue)
                        .cornerRadius(14)
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    FloatingButtonsSwiftUIView(viewModel: FloatingButtonsViewModel())
}
