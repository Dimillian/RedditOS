//
//  CommentRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Backend

struct CommentRow: View {
    @StateObject private var viewModel: CommentViewModel
    
    init(comment: Comment) {
        _viewModel = StateObject(wrappedValue: CommentViewModel(comment: comment))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            CommentVoteView(viewModel: viewModel).padding(.top, 4)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    HStack(spacing: 6) {
                        if let richText = viewModel.comment.authorFlairRichtext, !richText.isEmpty {
                            FlairView(richText: richText,
                                      textColorHex: viewModel.comment.authorFlairTextColor,
                                      backgroundColorHex: viewModel.comment.authorFlairBackgroundColor,
                                      display: .small)
                        }
                        if viewModel.comment.isSubmitter == true {
                            Image(systemName: "music.mic")
                                .foregroundColor(.redditBlue)
                        } else {
                            Image(systemName: "person")
                        }
                        Text(viewModel.comment.author ?? "Unknown")
                            .font(.callout)
                            .fontWeight(.bold)
                    }
                    if let score = viewModel.comment.score {
                        Text(" · \(score.toRoundedSuffixAsString()) points  · ")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    if let date = viewModel.comment.createdUtc {
                        Text(date, style: .relative)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    if let awards = viewModel.comment.allAwardings, !awards.isEmpty {
                        AwardsView(awards: awards).padding(.leading, 8)
                    }
                }
                Text(viewModel.comment.body ?? "No comment content")
                    .font(.body)
                CommentActionsView(viewModel: viewModel)
                Divider()
            }.padding(.vertical, 4)
        }
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CommentRow(comment: static_comment)
            CommentRow(comment: static_comment)
            CommentRow(comment: static_comment)
            CommentRow(comment: static_comment)
        }
    }
}
