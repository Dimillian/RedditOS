//
//  SearchSubredditsPopover.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct PopoverSearchSubredditView: View {
    @EnvironmentObject private var userData: LocalDataStore
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        List {
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)
            if viewModel.isLoading {
                LoadingRow(text: nil)
            } else if let results = viewModel.results {
                ForEach(results) { result in
                    PopoverSearchSubredditRow(subreddit: result).onTapGesture {
                        userData.add(favorite: result)
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
        PopoverSearchSubredditView()
    }
}
