//
//  PostDetailContent.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import AVKit
import SDWebImageSwiftUI

struct PostDetailContent: View {
    let listing: Listing
    @Binding var redrawLink: Bool
    
    @ViewBuilder
    var body: some View {
        if let text = listing.selftext ?? listing.description {
            Text(text).font(.body)
        }
        if let video = listing.secureMedia?.video {
            HStack {
                Spacer()
                VideoPlayer(player: AVPlayer(url: video.url))
                    .frame(width: CGFloat(video.width), height: CGFloat(video.height))
                Spacer()
            }
        } else if let url = listing.url, let realURL = URL(string: url) {
            if realURL.pathExtension == "jpg" || realURL.pathExtension == "png" {
                HStack {
                    Spacer()
                    WebImage(url: realURL)
                        .resizable()
                        .indicator(.activity)
                        .aspectRatio(contentMode: .fit)
                        .background(Color.gray)
                        .frame(minWidth: 300, minHeight: 200)
                    Spacer()
                }
            } else {
                LinkPresentationView(url: realURL, redraw: $redrawLink)
            }
        }
    }
}

struct PostDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailContent(listing: static_listing, redrawLink: .constant(false))
    }
}
