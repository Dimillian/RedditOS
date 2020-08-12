//
//  PostDetailCommentsSection.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import UI

struct PostDetailCommentsSection: View {
    @ObservedObject var viewModel: PostViewModel
    private let placeholderComments = Array(repeating: static_comment, count: 10)
    
    var body: some View {
        Divider()
        
        Picker("Sort by", selection: $viewModel.commentsSort) {
            ForEach(Comment.Sort.allCases, id: \.self) { sort in
                Text(sort.label()).tag(sort)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .frame(width: 170)
        .padding(.bottom, 8)
        
        RecursiveView(data: viewModel.comments ?? placeholderComments,
                      children: \.repliesComments) { comment in
            CommentRow(comment: comment)
                .redacted(reason: viewModel.comments == nil ? .placeholder : [])
        }
    }
}
