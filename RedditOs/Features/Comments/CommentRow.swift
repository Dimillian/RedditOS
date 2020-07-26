//
//  CommentRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Backend

struct CommentRow: View {
    let comment: Comment
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text(comment.author ?? "Unknown")
                    .font(.callout)
                    .fontWeight(.bold)
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
                .padding(.bottom, 4)
            Divider()
        }.padding(.vertical, 4)
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
