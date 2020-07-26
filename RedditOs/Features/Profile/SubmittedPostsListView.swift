//
//  SubmittedPostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Backend

struct SubmittedPostsListView: View {
    @EnvironmentObject private var currentUser: CurrentUserStore
    @State private var displayMode = SubredditPostRow.DisplayMode.large
    
    var body: some View {
        NavigationView {
            PostsListView(posts: currentUser.submittedPosts,
                          displayMode: $displayMode) {
                currentUser.fetchSubmitted(after: currentUser.submittedPosts?.last)
            }.onAppear {
                currentUser.fetchSubmitted(after: nil)
            }
            PostNoSelectionPlaceholder()
        }
        .navigationTitle("Saved")
        .onAppear {
            currentUser.fetchSaved(after: nil)
        }
    }
}

struct SubmittedPostsListView_Previews: PreviewProvider {
    static var previews: some View {
        SubmittedPostsListView()
    }
}
