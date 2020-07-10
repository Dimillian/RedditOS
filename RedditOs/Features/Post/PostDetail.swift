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
    @StateObject private var viewModel: PostDetailViewModel
    @State private var redrawLink = false
    
    init(listing: Listing) {
        _viewModel = StateObject(wrappedValue: PostDetailViewModel(listing: listing))
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                ListingInfoView(listing: viewModel.listing)
                PostDetailHeader(listing: viewModel.listing)
                PostDetailContent(listing: viewModel.listing, redrawLink: $redrawLink)
                PostDetailActions(listing: viewModel.listing)
            }.padding(.bottom, 16)
            PostDetailCommentsSection(comments: viewModel.comments)
        }
        .onAppear(perform: viewModel.fechComments)
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
