//
//  SearchSubredditsPopover.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct SearchSubredditsPopover: View {
    @EnvironmentObject private var userData: PersistedContent
    @StateObject private var viewModel = SearchSubredditsViewModel()
    
    var body: some View {
        List {
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)
            if viewModel.isLoading {
                LoadingRow(text: nil)
            } else if let results = viewModel.results {
                ForEach(results) { result in
                    SubredditRow(subreddit: result).onTapGesture {
                        userData.subreddits.append(result)
                    }
                }
            }
        }
        .navigationTitle("Search")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {}) {
                    Image(systemName: "xmark.circle")
                }
            }
        }
    }
}

struct SearchSheet_Previews: PreviewProvider {
    static var previews: some View {
        SearchSubredditsPopover()
    }
}
