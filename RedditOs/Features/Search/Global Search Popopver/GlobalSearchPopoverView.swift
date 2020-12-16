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
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                makeTitle("Quick access")
                makeQuickAccess()
                
                Divider()
                
                makeTitle("My subscriptions")
                makeMySubscriptionsSearch()
                
                Divider()
                
                makeTitle("Subreddit search")
                makeSubredditSearch()
                
            }.padding()
        }.frame(width: 300, height: 500)
    }
    
    private func makeTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
    }
    
    private func makeQuickAccess() -> some View {
        Group {
            GlobalSearchSubRow(icon: nil,
                               name: "Go to r/\(viewModel.searchText)")
                .onTapGesture {
                    uiState.presentedNavigationRoute = .subreddit(subreddit: viewModel.searchText, isSheet: false)
                }
            GlobalSearchSubRow(icon: nil,
                               name: "Go to u/\(viewModel.searchText)")
        }.padding(4)
    }
    
    private func makeMySubscriptionsSearch() -> some View {
        Group {
            if let subs = viewModel.filteredSubscriptions {
                if subs.isEmpty {
                    Label("No matching subscriptions for \(viewModel.searchText)", systemImage: "magnifyingglass")
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
            if let results = viewModel.results {
                if results.isEmpty {
                    Label("No matching search for \(viewModel.searchText)", systemImage: "magnifyingglass")
                } else {
                    ForEach(results) { sub in
                        makeSubRow(icon: sub.iconImg, name: sub.name)
                    }
                }
            } else if viewModel.isLoading {
                LoadingRow(text: nil)
            }
        }.padding(4)
    }
    
    private func makeSubRow(icon: String?, name: String) -> some View {
        GlobalSearchSubRow(icon: icon, name: name)
            .onTapGesture {
                uiState.presentedNavigationRoute = .subreddit(subreddit: name, isSheet: false)
        }
    }
}
