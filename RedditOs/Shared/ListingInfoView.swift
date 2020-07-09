//
//  ListingInfoView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct ListingInfoView: View {
    let listing: Listing
    var body: some View {
        HStack(spacing: 6) {
            Text("r/\(listing.subreddit)")
                .fontWeight(.bold)
                .font(.subheadline)
            Group {
                Text("Posted by u/\(listing.author)") +
                    Text(" ") +
                    Text(listing.created,
                         style: .relative) +
                    Text(" ") +
                    Text("ago")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
    }
}

struct ListingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ListingInfoView(listing: static_listing)
    }
}
