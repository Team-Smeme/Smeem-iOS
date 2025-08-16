import SwiftUI

struct BookmarkView: View {
    
    @State var model = BookmarkModel(bookmarks: [])
    let service = BookmarkService()
    
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
                    
                    // Pinterest Grid
                    HStack(alignment: .top, spacing: 16) {
                        LazyVStack(spacing: 16) {
                            ForEach(leftColumnItems) { item in
                                NavigationLink {
                                    BookmarkDetailView(
                                        id: item.id
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
                                        id: item.id
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
