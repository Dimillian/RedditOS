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
    enum DisplayMode: String, CaseIterable {
        case compact, large
        
        func iconName() -> String {
            switch self {
            case .compact: return "list.bullet"
            case .large: return "list.bullet.below.rectangle"
            }
        }
    }
    
    let listing: SubredditPost
    let displayMode: DisplayMode
    
    @Environment(\.openURL) private var openURL
        
    var body: some View {
        NavigationLink(destination: PostDetail(listing: listing)) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 8) {
                        ListingVoteView(listing: listing)
                        
                        if displayMode == .large {
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
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(listing.title)
                                .fontWeight(.bold)
                                .font(.headline)
                                .lineLimit(displayMode == .compact ? 2 : nil)
                            HStack {
                                if listing.linkFlairText?.isEmpty == false {
                                    Text(listing.linkFlairText!)
                                        .font(.callout)
                                        .fontWeight(.light)
                                        .padding(4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color("RedditBlue")))
                                }
                                if displayMode == .large,
                                   let urlString = listing.url,
                                   let url = URL(string: urlString) {
                                    Link(destination: url) {
                                        Text(url.host ?? url.absoluteString)
                                    }
                                }
                            }
                            ListingInfoView(listing: listing)
                            HStack(spacing: 6) {
                                Image(systemName: "bubble.middle.bottom.fill")
                                    .imageScale(.small)
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
        .contextMenu {
            Button {
                if let url = listing.redditURL {
                    openURL(url)
                }
            } label: { Text("Open in browser") }
            Button {
                if let url = listing.redditURL {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(url.absoluteString, forType: .string)
                }
                
            } label: { Text("Copy URL") }
        }
    }
}

struct SubredditPostRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SubredditPostRow(listing: static_listing, displayMode: .large)
            SubredditPostRow(listing: static_listing, displayMode: .large)
            SubredditPostRow(listing: static_listing, displayMode: .large)
            
            Divider()
            
            SubredditPostRow(listing: static_listing, displayMode: .compact)
            SubredditPostRow(listing: static_listing, displayMode: .compact)
            SubredditPostRow(listing: static_listing, displayMode: .compact)
        }
    }
}
