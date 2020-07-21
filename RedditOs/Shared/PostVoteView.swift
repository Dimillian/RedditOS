//
//  PostVoteView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct PostVoteView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        VStack(spacing: 2) {
            Button(action: {
                viewModel.post.vote(vote: viewModel.post.likes == true ? .neutral : .upvote)
            },
            label: {
                Image(systemName: "arrowtriangle.up.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(viewModel.post.likes == true ? .accentColor : nil)
            }).buttonStyle(BorderlessButtonStyle())
            
            Text(viewModel.post.ups.toRoundedSuffixAsString())
                .fontWeight(.bold)
            
            Button(action: {
                viewModel.post.vote(vote: viewModel.post.likes == false ? .neutral : .downvote)
            },
            label: {
                Image(systemName: "arrowtriangle.down.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(viewModel.post.likes == false ? .redditBlue : nil)
            }).buttonStyle(BorderlessButtonStyle())
        }.frame(width: 40)
    }
}

struct ListingVoteView_Previews: PreviewProvider {
    static var previews: some View {
        PostVoteView(viewModel: PostViewModel(post: static_listing))
    }
}
