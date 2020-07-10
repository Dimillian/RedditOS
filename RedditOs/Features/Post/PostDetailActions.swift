//
//  PostDetailActions.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend

struct PostDetailActions: View {
    let listing: Listing
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "bubble.middle.bottom.fill")
                    .imageScale(.small)
                    .foregroundColor(.white)
                Text("\(listing.numComments) comments")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.small)
                    .foregroundColor(.white)
                Text("Share")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "bookmark")
                    .imageScale(.small)
                    .foregroundColor(.white)
                Text("Save")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "flag")
                    .imageScale(.small)
                    .foregroundColor(.white)
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
