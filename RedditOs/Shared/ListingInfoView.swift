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
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text("r/\(listing.subreddit)")
                    .fontWeight(.bold)
                    .font(.subheadline)
                Text("Posted by u/\(listing.author)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Group {
                Text(listing.createdUtc,
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
