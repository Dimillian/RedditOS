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
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    if let url = listing.thumbnailURL {
                        WebImage(url: url)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .frame(width: 80, height: 60)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 80, height: 60)
                            .foregroundColor(Color.gray)
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
            }.padding(.vertical, 8)
        }
    }
}

struct SubredditPostRow_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostRow(listing: static_listing)
    }
}
