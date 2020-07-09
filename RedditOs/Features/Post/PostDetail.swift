//
//  PostDetail.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct PostDetail: View {
    let listing: Listing
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                ListingInfoView(listing: listing)
                Text(listing.title).font(.title)
                Text(listing.selftext).font(.body)
                HStack {
                    Spacer()
                    if let url = listing.thumbnailURL {
                        WebImage(url: url)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .frame(width: 400, height: 250)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 400, height: 250)
                            .foregroundColor(.gray)
                    }
                    Spacer()
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
        .frame(minWidth: 250,
               maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(listing: static_listing)
    }
}
