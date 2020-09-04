//
//  PostDetailHeader.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import KingfisherSwiftUI

struct PostDetailHeader: View {
    let listing: SubredditPost
    
    var body: some View {
        HStack {
            Text(listing.title)
                .font(.title)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
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
