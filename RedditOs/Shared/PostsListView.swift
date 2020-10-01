//
//  PostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 25/07/2020.
//

import SwiftUI
import Backend

struct PostsListView: View {
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    let posts: [SubredditPost]?
    @Binding var displayMode: SubredditPostRow.DisplayMode
    var onNextPage: (() -> Void)
    
    var body: some View {
        List {
            ForEach(posts ?? loadingPlaceholders) { post in
                SubredditPostRow(post: post,
                                 displayMode: $displayMode)
                    .redacted(reason: posts == nil ? .placeholder : [])
            }.animation(nil)
            if posts != nil {
                LoadingRow(text: "Loading next page")
                    .onAppear {
                        self.onNextPage()
                    }
            }
        }
        .listStyle(InsetListStyle())
        .frame(width: 500)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView(posts: nil,
                      displayMode: .constant(.large),
                      onNextPage: {
            
        })
    }
}
