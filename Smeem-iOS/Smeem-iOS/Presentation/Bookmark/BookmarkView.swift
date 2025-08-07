//
//  BookmarkView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/3/25.
//

import SwiftUI

struct BookmarkView: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("북마크")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0..<10) { index in
                            BookmarkCardView()
                                .offset(y: index % 2 == 0 ? 24 : -24) // ✅ 사선 오프셋 적용
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct BookmarkCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("sample-image") // ✅ 여기에 이미지 이름 또는 URL
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipped()
                .cornerRadius(12)

            Text("SmeemSmeemSmeemSmeemSmeem")
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)

            Text("“감소 -는 씨앗자? 같아요?”😳")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .truncationMode(.tail)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
