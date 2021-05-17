//
//  GlobalSearchPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 05/08/2020.
//

import SwiftUI
import Backend

struct QuickSearchResultsView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var currentUser: CurrentUserStore
    @EnvironmentObject private var searchState: QuickSearchState
    
    struct ResultContainerView<Content: View>: View {
        private let content: Content
        
        init(@ViewBuilder content: @escaping () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            Group {
                content
            }.padding(4)
        }
    }
  
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
        ResultContainerView {
            QuickSearchResultRow(icon: nil,
                                       name: "Posts with '\(searchState.searchText)'")
                .onTapGesture {
                    uiState.searchRoute = .searchPostsResult
                }
            
            QuickSearchResultRow(icon: nil,
                                       name: "Go to r/\(searchState.searchText)")
                .onTapGesture {
                    uiState.searchRoute = .subreddit(subreddit: searchState.searchText)
                }
        }
    }
    
    private func makeMySubscriptionsSearch() -> some View {
        ResultContainerView {
            if let subs = searchState.filteredSubscriptions {
                if subs.isEmpty {
                    Label("No matching subscriptions for \(searchState.searchText)",
                          systemImage: "exclamationmark.triangle")
                        .foregroundColor(.textColor)
                } else {
                    ForEach(subs) { sub in
                        makeSubRow(icon: sub.iconImg, name: sub.displayName)
                    }
                }
            }
        }
    }
    
    private func makeSubredditSearch() -> some View {
        ResultContainerView {
            if searchState.isLoading {
                LoadingRow(text: nil)
            } else if let results = searchState.results {
                if results.isEmpty {
                    Label("No matching search for \(searchState.searchText)",
                          systemImage: "exclamationmark.triangle")
                        .foregroundColor(.textColor)
                } else {
                    ForEach(results) { sub in
                        makeSubRow(icon: sub.iconImg, name: sub.name)
                    }
                }
            }
        }
    }
    
    private func makeSubRow(icon: String?, name: String) -> some View {
        QuickSearchResultRow(icon: icon, name: name)
            .onTapGesture {
                uiState.searchRoute = .subreddit(subreddit: name)
        }
    }
}
