//
//  SubredditPostThubnailView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 21/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct SubredditPostThumbnailView: View {
    let post: SubredditPost
    
    @ViewBuilder
    var body: some View {
        if let url = post.thumbnailURL {
            WebImage(url: url)
                .frame(width: 80, height: 60)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
        } else {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 80, height: 60)
                    .foregroundColor(Color.gray)
                if post.url != nil {
                    if post.selftext == nil || post.selftext?.isEmpty == true {
                        Image(systemName: "link")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct SubredditPostThubnailView_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostThumbnailView(post: static_listing)
    }
}
