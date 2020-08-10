//
//  PostDetailView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import AVKit

struct PostDetailView: View {
    @EnvironmentObject private var uiState: UIState
    @ObservedObject var viewModel: PostViewModel
    @State private var redrawLink = false
        
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    PostVoteView(viewModel: viewModel)
                    VStack(alignment: .leading) {
                        PostInfoView(post: viewModel.post)
                        PostDetailHeader(listing: viewModel.post)
                    }
                }
                PostDetailContent(listing: viewModel.post, redrawLink: $redrawLink)
                PostDetailActionsView(viewModel: viewModel)
            }.padding(.bottom, 16)
            PostDetailCommentsSection(comments: viewModel.comments)
        }
        .onAppear(perform: viewModel.fechComments)
        .onAppear(perform: viewModel.postVisit)
        .onAppear(perform: {
            uiState.selectedPost = viewModel.post
        })
        .onDisappear(perform: {
            uiState.selectedPost = nil
        })
        .frame(minWidth: 500,
               maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(viewModel: PostViewModel(post: static_listing))
    }
}
