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
            makeRow(comment: comment)
                .redacted(reason: comments == nil ? .placeholder : [])
        }
    }
    
    func makeRow(comment: Comment) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(comment.author ?? "Unknown")
                    .font(.footnote)
                if let score = comment.score {
                    Text(" · \(score.toRoundedSuffixAsString()) points  · ")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                if let date = comment.createdUtc {
                    Text(date, style: .relative)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            Text(comment.body ?? "No comment content")
                .font(.body)
            Divider()
        }.padding(.vertical, 4)
    }
}

struct PostCommentsSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostDetailCommentsSection(comments: static_comments)
        }
    }
}
