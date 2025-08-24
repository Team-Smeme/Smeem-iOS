//
//  BookmarkDetailView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/10/25.
//

import SwiftUI

struct BookmarkDetailView: View {
    
    let service = BookmarkService()
    @State var model: BookmarkDetailResponse?
    @State private var showDiaryVC = false
    @State private var showActionSheet = false
    @State private var showDeleteAlert = false
    let bookmarkId: Int
    let url: String?
    @Environment(\.dismiss) private var dismiss
    @State var bookmarkCount = 0
    var onDeleted: (() -> Void)?
    @State var isPresented = false
    
    // Navigation Bar background 적용
    init(id: Int, url: String? = nil, onDeleted: (() -> Void)? = nil) {
        self.bookmarkId = id
        self.url = url
        self.onDeleted = onDeleted
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0) // 원하는 배경색
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            // 메인 콘텐츠
            ScrollView {
                VStack(spacing: 16) {
                    // 👇 이미지 + 인스타 버튼 + 표현/부제 묶음
                    VStack(spacing: 12) {
                        // 이미지
                        AsyncImage(url: URL(string: self.model?.thumbnailImageUrl ?? "")) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.1)
                                    .frame(width: 132, height: 190)
                                    .cornerRadius(12)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()   // 채우되 잘리는 건 허용
                                    .frame(width: 132, height: 190)
                                    .clipped()
                                    .cornerRadius(12)
                            case .failure:
                                Image("bookmarkImageEmpty")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 132, height: 190)
                                    .cornerRadius(12)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        // Instagram 버튼
                        if let urlString = self.model?.scrapedUrl,
                           let url = URL(string: urlString) {
                            Link(destination: url) {
                                HStack(alignment: .center, spacing: 4) {
                                    Image("link")
                                    Text("Instagram")
                                        .font(Font.custom("Pretendard", size: 12).weight(.regular))
                                        .foregroundColor(Color(red: 0.14, green: 0.16, blue: 0.18))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.white)
                                .cornerRadius(4)
                                .overlay(
                                  RoundedRectangle(cornerRadius: 4)
                                    .inset(by: -0.5)
                                    .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                                )
                            }
                        } else {
                            // URL이 유효하지 않을 때 대체 UI
                            Text("링크를 사용할 수 없습니다")
                        }
                        
                        // 표현 / 부제
                        VStack(spacing: 4) {
                            Text(self.model?.expression ?? "")
                                .font(Font.custom("Pretendard", size: 19).weight(.semibold))
                                .multilineTextAlignment(.center)
                            Text(self.model?.translatedExpression ?? "")
                                .font(Font.custom("Pretendard", size: 15).weight(.medium))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)))
                    .overlay(
                        
                    Rectangle()
                        .inset(by: -0.5)
                        .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                    )
                    
                    // 예문 리스트
                    VStack(alignment: .leading, spacing: 16) {
                        Text(self.trimText(self.model?.description ?? ""))
                            .font(Font.custom("Pretendard", size: 15).weight(.regular))
                        
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 18)
                }
                .padding(.bottom, 100) // 플로팅 버튼 높이만큼 여백 추가
            }
            
            // 플로팅 버튼
            VStack {
                Spacer()
                
                Button(action: {
                    print("이 표현 써보기 클릭")
                    self.isPresented.toggle()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                        Text("이 표현 써보기")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: 153)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(50)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    BookmarkDiaryView(
                        expression: self.model?.expression ?? "",
                        translatedExpression: self.model?.translatedExpression ?? "")
                        }
                .padding(.horizontal, 18)
                .padding(.bottom, 21) // 안전 영역 고려
                .background(
                    // 그라데이션 배경으로 자연스러운 효과
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.8),
                            Color.white
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 커스텀 뒤로가기 버튼
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("북마크")
                    }
                    .foregroundColor(.black)
                }
            }
            
            // 오른쪽 버튼
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
                .confirmationDialog("작업 선택", isPresented: $showActionSheet, titleVisibility: .hidden) {
                                Button("수정하기") {
                                    // 수정 동작
                                    print("수정하기 선택됨")
                                }
                                Button("삭제하기", role: .destructive) {
                                    // 삭제 전 확인 alert 띄우기
                                    showDeleteAlert = true
                                }
                                Button("취소", role: .cancel) { }
                            }
                            .alert("해당 북마크를 삭제할까요?", isPresented: $showDeleteAlert) {
                                Button("취소", role: .cancel) { }
                                Button("확인", role: .destructive) {
                                    Task {
                                        do {
                                            let _ = try await service.deleteBookmarkAPI(bookmarkId: self.bookmarkId)
                                            onDeleted?()
                                            dismiss()
                                        } catch {
                                            print("bookmark delete 실패")
                                        }
                                    }
                                }
                            }
            }
        }
        .onAppear {
            Task {
                do {
                    if self.bookmarkId != 0 {
                        self.model = try await service.bookmarkDetailAPI(bookmarkID: self.bookmarkId)
                    } else {
                        // 여기서는 url을 통신한다.
                        guard let url = self.url else { return }
                        let response = try await service.bookmarkPostAPI(request: BookmarkRequest(url: url))
                        
                        self.model = BookmarkDetailResponse(
                            thumbnailImageUrl: response.scrapContent.thumbnail,
                            scrapedUrl: response.scrapContent.url,
                            expression: response.expression,
                            translatedExpression: response.translatedExpression,
                            description: self.trimText(response.scrapContent.description))

                        self.bookmarkCount = response.scrapedCountPerDay
                    }
                } catch {
                    print("bookmarkAPI 오류")
                }
            }
        }
    }
    
    func trimText(_ text: String) -> String {
        if let range = text.range(of: #"\"(.*?)\""#, options: .regularExpression) {
            let extracted = String(text[range]).trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            return extracted
        }
        return ""
    }
    
    
}

// 예문 모델
struct ExampleItem: Identifiable {
    let id = UUID()
    let expression: String
    let meaning: String
    let exampleSentence: String
    let translation: String
}

// 미리보기
#Preview {
    NavigationView {
        BookmarkDetailView(id: 1)
    }
}
