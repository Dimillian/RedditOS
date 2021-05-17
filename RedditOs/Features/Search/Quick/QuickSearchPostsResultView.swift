//
//  QuickSearchPostsResultView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI

struct QuickSearchPostsResultView: View {
    @EnvironmentObject private var searchState: QuickSearchState
    
    var body: some View {
        List {
            if searchState.isLoading {
                LoadingRow(text: "Searching...")
            } else if let results = searchState.postResults, !results.isEmpty {
                ForEach(results) { result in
                    SubredditPostRow(post: result, displayMode: .constant(.large))
                }
            } else {
                Label("No matching search for \(searchState.searchText)",
                      systemImage: "exclamationmark.triangle")
                    .foregroundColor(.textColor)
            }
        }
    }
}

struct QuickSearchPostsResultView_Previews: PreviewProvider {
    static var previews: some View {
        QuickSearchPostsResultView()
    }
}
