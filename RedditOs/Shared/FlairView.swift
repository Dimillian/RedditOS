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
    
    @ViewBuilder
    var body: some View {
        if post.linkFlairText == nil || post.linkFlairText?.isEmpty == true {
            EmptyView()
        } else {
            Text(post.linkFlairText!)
                .foregroundColor(post.linkFlairTextColor == "dark" ? .black : .white)
                .font(.callout)
                .fontWeight(.light)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(post.linkFlairBackgroundColor != nil ?
                                Color(hex: post.linkFlairBackgroundColor!) :
                                .redditBlue))
        }
    }
}

struct FlairView_Previews: PreviewProvider {
    static var previews: some View {
        FlairView(post: static_listing)
    }
}
