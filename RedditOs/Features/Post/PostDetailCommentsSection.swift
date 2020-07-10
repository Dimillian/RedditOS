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
    
    @ViewBuilder
    var body: some View {
        if let comments = comments {
            ForEach(comments) { comment in
                makeRow(comment: comment)
            }
        } else {
            LoadingRow(text: "")
        }
    }
    
    func makeRow(comment: Comment) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(comment.author ?? "Unknown")
                    .foregroundColor(.white)
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
                .foregroundColor(.white)
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
