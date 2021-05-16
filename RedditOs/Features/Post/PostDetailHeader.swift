//
//  PostDetailHeader.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import Kingfisher

struct PostDetailHeader: View {
    let listing: SubredditPost
    
    var body: some View {
        HStack {
            Text(listing.title)
                .font(.title)
                .lineLimit(10)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
                .fixedSize(horizontal: false, vertical: true)        
            if let url = listing.thumbnailURL, url.pathExtension != "jpg", url.pathExtension != "png" {
                KFImage(url)
                    .frame(width: 80, height: 60)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            }
            Spacer()
        }
    }
}

struct PostDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailHeader(listing: static_listing)
    }
}
