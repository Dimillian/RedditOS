//
//  PostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 25/07/2020.
//

import SwiftUI
import Backend

struct PostsListView<Header: View>: View, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.posts?.count == rhs.posts?.count &&
            rhs.displayMode == lhs.displayMode
    }
    
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    @ViewBuilder var header: () -> Header
    let posts: [SubredditPost]?
    @Binding var displayMode: SubredditPostRow.DisplayMode
    var onNextPage: (() -> Void)
    
    var body: some View {
        List {
            header()
            ForEach(posts ?? loadingPlaceholders) { post in
                SubredditPostRow(post: post,
                                 displayMode: $displayMode)
                    .equatable()
                    .redacted(reason: posts == nil ? .placeholder : [])
            }
            if posts != nil {
                LoadingRow(text: "Loading next page")
                    .onAppear {
                        self.onNextPage()
                    }
            }
        }
        .listStyle(.inset)
        .frame(minWidth: 400, idealWidth: 500, maxWidth: 700)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView(header: { EmptyView() },
                      posts: nil,
                      displayMode: .constant(.large),
                      onNextPage: {
            
        })
    }
}
