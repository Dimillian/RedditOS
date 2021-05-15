//
//  GlobalSearchPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 05/08/2020.
//

import SwiftUI
import Backend

struct GlobalSearchPopoverView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var currentUser: CurrentUserStore
    @EnvironmentObject private var searchState: SearchState
    
    var body: some View {
        Section(header: makeTitle("Quick access")) {
            makeQuickAccess()
        }
        
        Divider()
        
        Section(header: makeTitle("My subscriptions")) {
            makeMySubscriptionsSearch()
        }
  
        Divider()
        
        Section(header: makeTitle("Subreddit search")) {
            makeSubredditSearch()
        }
    }
    
    private func makeTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
    }
    
    private func makeQuickAccess() -> some View {
        Group {
            GlobalSearchSubRow(icon: nil,
                               name: "Go to r/\(searchState.searchText)")
                .onTapGesture {
                    uiState.searchRoute = .subreddit(subreddit: searchState.searchText)
                }
            GlobalSearchSubRow(icon: nil,
                               name: "Go to u/\(searchState.searchText)")
        }.padding(4)
    }
    
    private func makeMySubscriptionsSearch() -> some View {
        Group {
            if let subs = searchState.filteredSubscriptions {
                if subs.isEmpty {
                    Label("No matching subscriptions for \(searchState.searchText)", systemImage: "magnifyingglass")
                } else {
                    ForEach(subs) { sub in
                        makeSubRow(icon: sub.iconImg, name: sub.displayName)
                    }
                }
            }
        }.padding(4)
    }
    
    private func makeSubredditSearch() -> some View {
        Group {
            if let results = searchState.results {
                if results.isEmpty {
                    Label("No matching search for \(searchState.searchText)", systemImage: "magnifyingglass")
                } else {
                    ForEach(results) { sub in
                        makeSubRow(icon: sub.iconImg, name: sub.name)
                    }
                }
            } else if searchState.isLoading {
                LoadingRow(text: nil)
            }
        }.padding(4)
    }
    
    private func makeSubRow(icon: String?, name: String) -> some View {
        GlobalSearchSubRow(icon: icon, name: name)
            .onTapGesture {
                uiState.searchRoute = .subreddit(subreddit: name)
        }
    }
}
