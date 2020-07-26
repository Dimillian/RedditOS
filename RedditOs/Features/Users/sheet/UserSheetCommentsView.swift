//
//  UserSheetCommentsView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Combine
import Backend

struct UserSheetCommentsView: View {
    @ObservedObject var viewModel: UserViewModel
    private let loadingPlaceholders = Array(repeating: static_comment, count: 20)
    
    var body: some View {
        List {
            ForEach(viewModel.comments ?? loadingPlaceholders) { comment in
                CommentRow(comment: comment).redacted(reason: viewModel.comments != nil ? [] : .placeholder)
            }
            if viewModel.comments != nil {
                LoadingRow(text: "Loading next page")
                    .onAppear {
                        viewModel.fetchComment(after: viewModel.comments?.last)
                }
            }
        }.frame(width: 500)
    }
}
