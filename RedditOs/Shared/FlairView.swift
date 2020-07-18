//
//  FlairView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/07/2020.
//

import SwiftUI
import Backend

struct FlairView: View {
    let post: SubredditPost
    
    var backgroundColor: Color {
        if let color = post.linkFlairBackgroundColor{
            if color.isEmpty {
                return .gray
            }
            return Color(hex: color)
        }
        return .redditBlue
    }
    
    var textColor: Color {
        if backgroundColor == .gray {
            return .white
        }
        return post.linkFlairTextColor == "dark" ? .black : .white
    }

    @ViewBuilder
    var body: some View {
        if post.linkFlairText == nil || post.linkFlairText?.isEmpty == true {
            EmptyView()
        } else {
            Text(post.linkFlairText!)
                .foregroundColor(textColor)
                .font(.callout)
                .fontWeight(.light)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(backgroundColor)
                )
        }
    }
}

struct FlairView_Previews: PreviewProvider {
    static var previews: some View {
        FlairView(post: static_listing)
    }
}
