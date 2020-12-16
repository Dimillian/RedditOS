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
    @State private var showUserPopover = false
    
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
                        if let author = viewModel.comment.author {
                            Button(action: {
                                showUserPopover = true
                            }, label: {
                                HStack(spacing: 4) {
                                    if viewModel.comment.isSubmitter == true {
                                        Image(systemName: "music.mic")
                                            .foregroundColor(.redditBlue)
                                    } else {
                                        Image(systemName: "person")
                                    }
                                    Text(author)
                                        .font(.callout)
                                        .fontWeight(.bold)
                                }
                            })
                            .buttonStyle(BorderlessButtonStyle())
                            .popover(isPresented: $showUserPopover, content: {
                                UserPopoverView(username: author)
                            })
                        } else {
                            Text("Deleted user")
                                .font(.footnote)
                        }
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
                if let body = viewModel.comment.body {
                    Text(body)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Deleted comment")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                CommentActionsView(viewModel: viewModel)
                    .foregroundColor(.gray)
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
