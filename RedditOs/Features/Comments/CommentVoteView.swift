//
//  CommentVoteView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 12/08/2020.
//

import SwiftUI
import Backend

struct CommentVoteView: View {
    @ObservedObject var viewModel: CommentViewModel
    
    var body: some View {
        HStack(spacing: 6) {
            Button(action: {
                viewModel.postVote(vote: viewModel.comment.likes == true ? .neutral : .upvote)
            },
            label: {
                Image(systemName: "arrowtriangle.up.circle")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(viewModel.comment.likes == true ? .accentColor : nil)
            }).buttonStyle(BorderlessButtonStyle())
            
            Text(viewModel.comment.score?.toRoundedSuffixAsString() ?? "Vote")
                .font(.callout)
                .lineLimit(1)
            
            Button(action: {
                viewModel.postVote(vote: viewModel.comment.likes == false ? .neutral : .downvote)
            },
            label: {
                Image(systemName: "arrowtriangle.down.circle")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(viewModel.comment.likes == false ? .redditBlue : nil)
            }).buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct CommentVoteView_Previews: PreviewProvider {
    static var previews: some View {
        CommentVoteView(viewModel: CommentViewModel(comment: static_comment))
    }
}
