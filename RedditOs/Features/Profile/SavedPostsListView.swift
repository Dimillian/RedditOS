//
//  SavedPostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 24/07/2020.
//

import SwiftUI
import Backend

struct SavedPostsListView: View {
    @EnvironmentObject private var currentUser: CurrentUserStore
    @State private var displayMode = SubredditPostRow.DisplayMode.large
    
    var body: some View {
        NavigationView {
            PostsListView(posts: currentUser.savedPosts,
                          displayMode: $displayMode) {
                currentUser.fetchSaved(after: currentUser.savedPosts?.last)
            }.onAppear {
                currentUser.fetchSaved(after: nil)
            }
            PostNoSelectionPlaceholder()
        }
        .navigationTitle("Saved")
        .onAppear {
            currentUser.fetchSaved(after: nil)
        }
    }
}

struct SavedPostListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPostsListView()
    }
}
