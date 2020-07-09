//
//  PostDetail.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI
import AVKit

struct PostDetail: View {
    let listing: Listing
    @State private var redrawLink = false
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                ListingInfoView(listing: listing)
                HStack {
                    Text(listing.title)
                        .font(.title)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    if let url = listing.thumbnailURL {
                        WebImage(url: url)
                            .frame(width: 80, height: 60)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                    }
                    Spacer()
                }.frame(width: 500)
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
                } else if let url = listing.url {
                    LinkPresentationView(url: url, redraw: $redrawLink)
                }
                
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
            }.padding(.bottom, 16)
            
            Section(header: Text("Comments")) {

            }
        }
        .listStyle(InsetListStyle())
        .frame(minWidth: 500,
               maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(listing: static_listing)
    }
}
