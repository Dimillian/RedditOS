//
//  PostDetailActions.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend

struct PostDetailActions: View {
    let listing: SubredditPost
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "bubble.middle.bottom.fill")
                    .imageScale(.small)
                Text("\(listing.numComments) comments")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.small)
                Text("Share")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "bookmark")
                    .imageScale(.small)
                Text("Save")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "flag")
                    .imageScale(.small)
                Text("Report")
            }
            
        }
    }
}

struct PostDetailActions_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailActions(listing: static_listing)
    }
}
