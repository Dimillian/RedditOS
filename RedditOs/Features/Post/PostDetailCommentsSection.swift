//
//  PostDetailCommentsSection.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend

struct PostDetailCommentsSection: View {
    let comments: [Comment]?
    private let placeholderComments = Array(repeating: static_comment, count: 10)
    
    var body: some View {
        OutlineGroup(comments ?? placeholderComments,
                     children: \.repliesComments) { comment in
            CommentRow(comment: comment)
                .redacted(reason: comments == nil ? .placeholder : [])
        }
    }
}

struct PostCommentsSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostDetailCommentsSection(comments: static_comments)
        }
    }
}
