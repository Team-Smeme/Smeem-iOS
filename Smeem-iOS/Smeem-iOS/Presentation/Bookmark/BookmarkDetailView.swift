//
//  BookmarkDetailView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/10/25.
//

import SwiftUI

struct BookmarkDetailView: View {
    var sharedContent: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("받은 북마크")
                .font(.largeTitle)
                .bold()
            
            Text(sharedContent ?? "")
                .font(.body)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("북마크")
    }
}
