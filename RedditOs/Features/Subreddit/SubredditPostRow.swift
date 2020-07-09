//
//  SubredditPostRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct SubredditPostRow: View {
    let listing: Listing
        
    var body: some View {
        NavigationLink(destination: PostDetail(listing: listing)) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 8) {
                        ListingVoteView(listing: listing)
                        if let url = listing.thumbnailURL {
                            WebImage(url: url)
                                .frame(width: 80, height: 60)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                        } else {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 80, height: 60)
                                    .foregroundColor(Color.gray)
                                if listing.url != nil {
                                    Image(systemName: "link")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(listing.title)
                                .fontWeight(.bold)
                                .font(.headline)
                            ListingInfoView(listing: listing)
                            HStack(spacing: 6) {
                                Image(systemName: "bubble.middle.bottom.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.white)
                                Text("\(listing.numComments) comments")
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(width: 390)
        .padding(.vertical, 8)
    }
}

struct SubredditPostRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SubredditPostRow(listing: static_listing)
            SubredditPostRow(listing: static_listing)
            SubredditPostRow(listing: static_listing)
        }
    }
}
