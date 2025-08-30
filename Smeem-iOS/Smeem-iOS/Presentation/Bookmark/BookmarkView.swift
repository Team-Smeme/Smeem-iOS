import SwiftUI

struct BookmarkView: View {
    
    @State var model = BookmarkModel(bookmarks: [])
    let service = BookmarkService()
    @State private var refreshTrigger = false
    
    init() {
        // UITabBar 배경 불투명하게 유지
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("북마크")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    // 북마크 없을 때 empty
                    if model.bookmarks.isEmpty {
                        VStack(spacing: 12) {
                            Image("iconExclamation")
                                .font(.system(size: 32))
                                .foregroundColor(.gray)
                            
                            Text("아직 저장한 북마크가 없어요.")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            Text("인스타그램에서 공유 버튼을 눌러\n북마크를 저장해보세요!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                openInstagram()
                            }) {
                                Text("인스타그램 열기")
                                    .font(.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 400) // 중앙 정렬을 위한 height
                        .padding(.top, 100)
                        
                    } else {
                        // Pinterest Grid
                        HStack(alignment: .top, spacing: 16) {
                            LazyVStack(spacing: 16) {
                                ForEach(leftColumnItems) { item in
                                    NavigationLink {
                                        BookmarkDetailView(
                                            id: item.id,
                                            onDeleted: {
                                                refreshTrigger.toggle()
                                            }
                                        )
                                    } label: {
                                        BookmarkCardView(bookmark: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            LazyVStack(spacing: 16) {
                                ForEach(rightColumnItems) { item in
                                    NavigationLink {
                                        BookmarkDetailView(
                                            id: item.id,
                                            onDeleted: {
                                                refreshTrigger.toggle()
                                            }
                                        )
                                    } label: {
                                        BookmarkCardView(bookmark: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                        .padding(.top)
                        .padding(.bottom, 49)
                }
                .toolbar(.hidden, for: .navigationBar)
            }
            .onAppear {
                Task {
                    do {
                        self.model = try await service.bookmarkGetAPI()
                    } catch {
                        print("bookmarkAPI 오류")
                    }
                }
            }
            .onChange(of: refreshTrigger) { _ in
                Task {
                    do {
                        self.model = try await service.bookmarkGetAPI()
                    } catch {
                        print("bookmarkAPI 오류")
                    }
                }
            }
        }
    
    // MARK: - Pinterest 컬럼 분배
    private var leftColumnItems: [Bookmarks] {
        distributeColumns().left
    }
    
    private var rightColumnItems: [Bookmarks] {
        distributeColumns().right
    }
    
    private func distributeColumns() -> (left: [Bookmarks], right: [Bookmarks]) {
        var left: [Bookmarks] = []
        var right: [Bookmarks] = []
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0
        
        for item in model.bookmarks {
            let height = BookmarkCardView.cardHeight(for: item)
            if leftHeight <= rightHeight {
                left.append(item)
                leftHeight += height + 16
            } else {
                right.append(item)
                rightHeight += height + 16
            }
        }
        return (left, right)
    }
    
    private func openInstagram() {
        if let url = URL(string: "instagram://app"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: "https://instagram.com") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - 카드 뷰
struct BookmarkCardView: View {
    let bookmark: Bookmarks
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: bookmark.thumbnailImageUrl)) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.1)
                        .frame(height: Self.cardHeight(for: bookmark))
                        .cornerRadius(12)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: Self.cardHeight(for: bookmark))
                        .clipped()
                        .cornerRadius(12)
                case .failure:
                    Image("bookmarkImageEmpty")
                        .resizable()
                        .scaledToFill()
                        .frame(height: Self.cardHeight(for: bookmark))
                        .clipped()
                        .cornerRadius(12)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(bookmark.expression)
                .font(.headline)
                .lineLimit(2)
            
            Text(self.trimText(bookmark.description))
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    func trimText(_ text: String) -> String {
        if let range = text.range(of: #"\"(.*?)\""#, options: .regularExpression) {
            let extracted = String(text[range]).trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            return extracted
        }
        return ""
    }
    
    // scrapType 기반 높이
    static func cardHeight(for bookmark: Bookmarks) -> CGFloat {
        switch bookmark.scrapType {
        case "POST": return 140
        case "REELS": return 238
        default: return 140
        }
    }
}


