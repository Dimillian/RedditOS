//
//  CommentRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Backend
import MarkdownUI

struct CommentRow: View {
    @StateObject private var viewModel: CommentViewModel
    @State private var showUserPopover = false
    
    var isFake: Bool {
        viewModel.comment.name == "t1_id"
    }
    
    let isRoot: Bool
    
    init(comment: Comment, isRoot: Bool) {
        self.isRoot = isRoot
        _viewModel = StateObject(wrappedValue: CommentViewModel(comment: comment))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if !isRoot {
                Rectangle()
                    .frame(width: 1)
                    .background(Color.white)
                    .padding(.bottom, 8)
            }
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
                    if isFake {
                        Text(body)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Markdown(Document(body))
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                } else {
                    Text("Deleted comment")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                HStack(spacing: 16) {
                    CommentVoteView(viewModel: viewModel)
                    CommentActionsView(viewModel: viewModel)
                        .foregroundColor(.gray)
                }
                Divider()
            }.padding(.vertical, 4)
        }
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CommentRow(comment: static_comment, isRoot: true)
            CommentRow(comment: static_comment, isRoot: false)
            CommentRow(comment: static_comment, isRoot: true)
            CommentRow(comment: static_comment, isRoot: false)
            CommentRow(comment: static_comment, isRoot: false)
            CommentRow(comment: static_comment, isRoot: false)
        }
        .frame(height: 800)
    }
}
