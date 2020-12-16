//
//  PostDetailContent.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import AVKit
import KingfisherSwiftUI

struct PostDetailContent: View {
    let listing: SubredditPost
    @Binding var redrawLink: Bool
    
    @ViewBuilder
    var body: some View {
        if let text = listing.selftext ?? listing.description {
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        if let video = listing.secureMedia?.video {
            HStack {
                Spacer()
                VideoPlayer(player: AVPlayer(url: video.url))
                    .frame(width: min(500, CGFloat(video.width)),
                           height: min(500, CGFloat(video.height)))
                Spacer()
            }
        } else if let url = listing.url, let realURL = URL(string: url) {
            if realURL.pathExtension == "jpg" || realURL.pathExtension == "png" {
                HStack {
                    Spacer()
                    KFImage(realURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.gray)
                        .frame(maxHeight: 400)
                        .padding()
                    Spacer()
                }
            } else if listing.selftext == nil || listing.selftext?.isEmpty == true {
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
