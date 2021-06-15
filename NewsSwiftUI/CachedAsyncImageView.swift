//
//  CachedAsyncImageView.swift
//  NewsSwiftUI
//
//  Created by Gary Hanson on 6/14/21.
//

import SwiftUI


struct CachedAsyncImageView: View {
    @State private var image: Image?
    var url: URL?
    
    var body: some View {
        ZStack {
            if let downloadedImage = image {
                downloadedImage
            } else {
                Color.mint  // better than a lot of spinning wheels. some of the images are not there or really, really slow to load
            }
        }
        .task(id: url) {
            do {
                if let url = url {
                    try await self.image = CachedImageDownloader.image(from: url)
                }
            } catch {
                // all of the errors should have been caught and thrown. not much we can do with them.
                // just leave placeholder up.
            }
        }
    }
}
