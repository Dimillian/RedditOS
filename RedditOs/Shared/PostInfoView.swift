//
//  ListingInfoView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct PostInfoView: View {
    let post: SubredditPost
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("r/\(post.subreddit)")
                .fontWeight(.bold)
                .font(.subheadline)
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "person")
                    Text("u/\(post.author)")
                }
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(post.createdUtc, style: .offset)
                }
                HStack(spacing: 4) {
                    Image(systemName: "bubble.middle.bottom")
                        .imageScale(.small)
                    Text("\(post.numComments)")
                }
            }
            .font(.callout)
            .foregroundColor(.gray)
        }
    }
}

struct ListingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PostInfoView(post: static_listing)
    }
}
