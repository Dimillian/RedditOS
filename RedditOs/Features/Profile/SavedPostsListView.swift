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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SavedPostListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPostsListView()
    }
}
